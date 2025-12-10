import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/widgets/MemberInfoDrawer.dart';
import 'package:painal/screens/vanshavali/widgets/edit_member_drawer.dart';
import 'package:painal/screens/vanshavali/widgets/add_member_drawer.dart';
import 'package:painal/screens/vanshavali/widgets/delete_confirmation_dialog.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_header.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_body.dart';
import 'package:provider/provider.dart';
import 'package:painal/apis/AuthProviderUser.dart';

Future<List<FamilyMember>> fetchFamilyMembers(String collectionName) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy('id') // Optional: for sorted results
          .get();

  return snapshot.docs.map((doc) => FamilyMember.fromMap(doc.data())).toList();
}

FamilyMember? buildFamilyTreeFromFlatData(
  List<FamilyMember> flatData,
  int rootId,
) {
  final Map<int, FamilyMember> memberMap = {for (var m in flatData) m.id: m};
  for (var member in flatData) {
    member.childMembers =
        member.children
            .map((id) => memberMap[id])
            .whereType<FamilyMember>()
            .toList();
  }
  return memberMap[rootId];
}

class VanshavaliScreen extends StatefulWidget {
  final String collectionName;
  final String heading;
  final String hindiHeading;
  final int? initialMemberId;
  final bool isMainFamily;

  const VanshavaliScreen({
    super.key,
    this.collectionName = 'familyMembers',
    this.heading = 'Vanshavali',
    this.hindiHeading = '(वंशावली - परिवार वृक्ष)',
    this.initialMemberId,
    this.isMainFamily = true,
  });

  @override
  State<VanshavaliScreen> createState() => _VanshavaliScreenState();
}

class _VanshavaliScreenState extends State<VanshavaliScreen> {
  List<FamilyMember>? _familyData;
  FamilyMember? _currentMember;
  final List<FamilyMember> _navigationStack = [];
  bool _loading = true;
  String? _error;
  DateTime? _localLastUpdated;
  DateTime? _remoteLastUpdated;
  bool _showUpdateBanner = false;

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
    _checkForRemoteUpdates();
  }

  String _getBoxName() {
    return widget.isMainFamily
        ? 'familyBox'
        : 'familyBox_${widget.collectionName}';
  }

  Future<Box<FamilyMember>> _getBox() async {
    final boxName = _getBoxName();
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<FamilyMember>(boxName);
    } else {
      return await Hive.openBox<FamilyMember>(boxName);
    }
  }

  Future<void> _checkForRemoteUpdates() async {
    bool updateNeeded = false;
    // Get the latest lastUpdated from Firestore
    final snapshot =
        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .orderBy('lastUpdated', descending: true)
            .limit(1)
            .get();
    if (snapshot.docs.isNotEmpty) {
      final remote = snapshot.docs.first.data()['lastUpdated'];
      if (remote != null) {
        final remoteTime = (remote as Timestamp).toDate();
        setState(() {
          _remoteLastUpdated = remoteTime;
        });
        // Compare with local
        final box = await _getBox();
        DateTime? localTime;
        for (var member in box.values) {
          if (member.lastUpdated != null) {
            final t = member.lastUpdated!;
            if (localTime == null || t.isAfter(localTime)) {
              localTime = t;
            }
          }
        }
        setState(() {
          _localLastUpdated = localTime;
          updateNeeded = localTime == null || remoteTime.isAfter(localTime);
        });
      }
    }
    // After checking main collection, also check other families
    try {
      final famSnap =
          await FirebaseFirestore.instance.collection('families').get();
      for (final doc in famSnap.docs) {
        final String? col = doc.data()['collectionName'];
        if (col == null || col.isEmpty) continue;

        // Get remote latest
        final remoteSnap =
            await FirebaseFirestore.instance
                .collection(col)
                .orderBy('lastUpdated', descending: true)
                .limit(1)
                .get();
        if (remoteSnap.docs.isEmpty) continue;
        final Timestamp? ts = remoteSnap.docs.first.data()['lastUpdated'];
        if (ts == null) continue;
        final remoteLatest = ts.toDate();

        // Get local latest
        DateTime? localLatest;
        final boxName = 'familyBox_$col';
        if (await Hive.boxExists(boxName)) {
          final box =
              Hive.isBoxOpen(boxName)
                  ? Hive.box<FamilyMember>(boxName)
                  : await Hive.openBox<FamilyMember>(boxName);
          for (final m in box.values) {
            final lu = m.lastUpdated;
            if (lu != null) {
              if (localLatest == null || lu.isAfter(localLatest)) {
                localLatest = lu;
              }
            }
          }
        }
        if (localLatest == null || remoteLatest.isAfter(localLatest)) {
          updateNeeded = true;
          break;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _showUpdateBanner = updateNeeded;
      });
    }
  }

  Future<void> _loadFamilyData({bool forceRefresh = false}) async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final box = await _getBox();
      List<FamilyMember> data = [];

      if (!forceRefresh && box.isNotEmpty) {
        data = box.values.toList();
      } else {
        data = await fetchFamilyMembers(widget.collectionName);
        await box.clear();
        await box.putAll({for (var member in data) member.id: member});
      }

      if (data.isEmpty) {
        if (mounted) {
          setState(() {
            _error = 'No family data found.';
            _loading = false;
          });
        }
        return;
      }

      // Build family tree
      final rootMembers = data.where((m) => m.parentId == null).toList();
      if (rootMembers.isEmpty) {
        if (mounted) {
          setState(() {
            _error = 'No root family member found.';
            _loading = false;
          });
        }
        return;
      }

      for (var root in rootMembers) {
        buildFamilyTreeFromFlatData(data, root.id);
      }

      // Find the most recent update time
      DateTime? localTime;
      for (var member in data) {
        if (member.lastUpdated != null &&
            (localTime == null || member.lastUpdated!.isAfter(localTime))) {
          localTime = member.lastUpdated;
        }
      }

      if (mounted) {
        setState(() {
          _familyData = data;
          _currentMember = rootMembers.first;
          _localLastUpdated = localTime;
          _loading = false;
        });

        // Handle deep link if requested
        if (widget.initialMemberId != null && !forceRefresh) {
          try {
            final targetMember = _familyData!.firstWhere(
              (m) => m.id == widget.initialMemberId,
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateToMember(targetMember);
              _showMemberDetails(targetMember);
            });
          } catch (_) {
            // Member not found or invalid
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading family data: $e\n$stackTrace');
      if (mounted) {
        setState(() {
          _error = 'Failed to load data: ${e.toString()}';
          _loading = false;
        });
      }
    }
    // After loading, check for remote updates again
    _checkForRemoteUpdates();
  }

  Future<void> _refreshFromFirebase() async {
    // Refresh main family data
    await _loadFamilyData(forceRefresh: true);
    // Refresh all additional families used in MoreFamilyScreen
    await _refreshOtherFamilies();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All family data refreshed!'),
      ), // unified message
    );
    setState(() {
      _showUpdateBanner = false;
    });
  }

  /// Fetches every family listed in the root `families` collection,
  /// pulls the latest members from Firestore, and updates their
  /// corresponding Hive boxes (familyBox_<collectionName>).
  Future<void> _refreshOtherFamilies() async {
    try {
      final familiesSnapshot =
          await FirebaseFirestore.instance.collection('families').get();
      for (final doc in familiesSnapshot.docs) {
        final data = doc.data();
        final String? collectionName = data['collectionName'];
        if (collectionName == null || collectionName.isEmpty) continue;

        final membersSnap =
            await FirebaseFirestore.instance.collection(collectionName).get();
        final members =
            membersSnap.docs
                .map((d) => FamilyMember.fromMap(d.data()))
                .toList();
        if (members.isEmpty) continue;

        final box = await Hive.openBox<FamilyMember>(
          'familyBox_$collectionName',
        );
        await box.clear();
        for (final member in members) {
          await box.put(member.id, member);
        }
      }
    } catch (e) {
      // For now just print, but avoid crashing refresh flow
      debugPrint('Error refreshing other families: \$e');
    }
  }

  void _navigateToChild(FamilyMember child) {
    setState(() {
      _navigationStack.add(_currentMember!);
      _currentMember = child;
    });
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _currentMember = _navigationStack.removeLast();
      });
    }
  }

  void _navigateToMember(FamilyMember member) {
    if (_familyData == null) return;
    List<FamilyMember> stack = [];
    FamilyMember? current = member;
    while (current?.parentId != null) {
      final parent = _familyData!.firstWhere(
        (m) => m.id == current!.parentId,
        orElse: () => current!,
      );
      if (parent.id == current!.id) break;
      stack.insert(0, parent);
      current = parent;
    }
    setState(() {
      _navigationStack
        ..clear()
        ..addAll(stack);
      _currentMember = member;
    });
  }

  void _showMemberDetails(FamilyMember member) {
    if (_familyData == null) return;

    final parent =
        member.parentId != null
            ? _familyData!.firstWhere(
              (m) => m.id == member.parentId,
              orElse: () => member,
            )
            : null;
    final children = member.childMembers;
    final siblings =
        member.parentId != null
            ? _familyData!
                .where(
                  (m) => m.parentId == member.parentId && m.id != member.id,
                )
                .toList()
            : <FamilyMember>[];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return MemberDetailsModal(
              member: member,
              parent: parent,
              children: children,
              siblings: siblings,
              onEdit: () {
                Navigator.of(context).pop();
                _showEditMemberDrawer(member);
              },
              onAdd: () {
                Navigator.of(context).pop();
                _showAddMemberDrawer(member);
              },
              onDelete: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(member);
              },
              onShowDetails: (m) {
                Navigator.of(context).pop();
                _showMemberDetails(m);
              },
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  void _showEditMemberDrawer(FamilyMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return EditMemberDrawer(
          member: member,
          collectionName: widget.collectionName,
          onSaved: () async {
            await _loadFamilyData(forceRefresh: true);
            final editedMemberInData = _familyData?.firstWhere(
              (m) => m.id == member.id,
              orElse: () => _familyData!.first,
            );
            if (editedMemberInData != null) {
              _navigateToMember(editedMemberInData);
            }
          },
        );
      },
    );
  }

  void _showAddMemberDrawer(FamilyMember parent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddMemberDrawer(
          parent: parent,
          familyData: _familyData!,
          collectionName: widget.collectionName,
          onSaved: () async {
            await _loadFamilyData(forceRefresh: true);
            final parentInData = _familyData?.firstWhere(
              (m) => m.id == parent.id,
              orElse: () => _familyData!.first,
            );
            if (parentInData != null) {
              _navigateToMember(parentInData);
            }
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(FamilyMember member) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DeleteConfirmationDialog(
          member: member,
          collectionName: widget.collectionName,
          onDeleted: () async {
            await _loadFamilyData(forceRefresh: true);
            // After deletion, go to root if current member was deleted
            if (_currentMember?.id == member.id) {
              final root = _familyData?.firstWhere(
                (m) => m.parentId == null,
                orElse: () => _familyData!.first,
              );
              if (root != null) {
                setState(() {
                  _currentMember = root;
                  _navigationStack.clear();
                });
              }
            } else {
              // If not, just refresh navigation stack
              setState(() {});
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthProviderUser>(context);
    bool showBanner = _showUpdateBanner && !userAuth.isAdmin;
    bool fetchingBanner = false;

    // Wrap loading and error states with background gradient
    if (_loading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
            stops: [0.0, 1.0],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Pop all routes until we're back at the list or root
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            title: Text(
              widget.heading,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
            stops: [0.0, 1.0],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Pop all routes until we're back at the list or root
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            title: Text(
              widget.heading,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (context, setState) {
                    return _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                          onPressed: () async {
                            setState(() => _loading = true);
                            try {
                              await _loadFamilyData(forceRefresh: true);
                              if (mounted && _error != null) {
                                setState(() => _loading = false);
                              }
                            } catch (e) {
                              if (mounted) {
                                setState(() {
                                  _error = 'Failed to load data: $e';
                                  _loading = false;
                                });
                              }
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (_familyData == null || _currentMember == null) {
      return const Center(child: Text('No data available.'));
    }
    final totalMembers = _familyData!.length;
    final double horizontalPadding = 12 + 12;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Pop all routes until we're back at the list or root
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          title: Text(
            'Vanshavali',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Header section
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (showBanner)
                        StatefulBuilder(
                          builder: (context, setBannerState) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.16),
                                    Colors.white.withOpacity(0.06),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange.shade200,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Family data has changed. Please get the latest data.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  fetchingBanner
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                      : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange
                                              .withOpacity(0.9),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setBannerState(
                                            () => fetchingBanner = true,
                                          );
                                          await _refreshFromFirebase();
                                          setBannerState(
                                            () => fetchingBanner = false,
                                          );
                                        },
                                        child: const Text(
                                          'Get Latest Data',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            );
                          },
                        ),
                      VanshavaliHeader(
                        totalMembers: totalMembers,
                        heading: widget.heading,
                        hindiHeading: widget.hindiHeading,
                        onRefresh: _refreshFromFirebase,
                        showRefresh: userAuth.isAdmin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Body section
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = MediaQuery.of(context).size.width;
                  final double contentWidth = screenWidth - horizontalPadding;
                  final double maxContentWidth = 900;
                  final double cardWidth =
                      contentWidth > maxContentWidth
                          ? maxContentWidth
                          : contentWidth;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: screenWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                width: cardWidth,
                                margin: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 18,
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  10,
                                  10,
                                  20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.18),
                                      Colors.white.withOpacity(0.08),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: VanshavaliBody(
                                  currentMember: _currentMember!,
                                  navigationStack: _navigationStack,
                                  onNavigateBack: _navigateBack,
                                  onNavigateToChild: _navigateToChild,
                                  onCardTap: _showMemberDetails,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateDialog extends StatefulWidget {
  final Future<void> Function() onFetch;
  const _UpdateDialog({required this.onFetch});

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.colorScheme.secondary;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: theme.colorScheme.surface,
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: green, size: 28),
          const SizedBox(width: 10),
          Text(
            'Family Data Changed',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          'Family data has changed. Please get the latest data to continue.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed:
                _loading
                    ? null
                    : () async {
                      setState(() => _loading = true);
                      await widget.onFetch();
                      if (mounted) Navigator.of(context).pop();
                    },
            child:
                _loading
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.onPrimary,
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Getting Latest Data...'),
                      ],
                    )
                    : const Text(
                      'Get Latest Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}
