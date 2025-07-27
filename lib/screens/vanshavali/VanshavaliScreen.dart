import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/widgets/search_dialog.dart';
import 'package:painal/screens/vanshavali/widgets/MemberInfoDrawer.dart';
import 'package:painal/screens/vanshavali/widgets/edit_member_drawer.dart';
import 'package:painal/screens/vanshavali/widgets/add_member_drawer.dart';
import 'package:painal/screens/vanshavali/widgets/delete_confirmation_dialog.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_header.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_body.dart';
import 'package:provider/provider.dart';
import 'package:painal/apis/AuthProviderUser.dart';
import 'package:painal/screens/vanshavali/more-family/MoreFamilyScreen.dart';

Future<List<FamilyMember>> fetchFamilyMembers() async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('familyMembers')
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
    member.childMembers = member.children.map((id) => memberMap[id]!).toList();
  }
  return memberMap[rootId];
}

class VanshavaliScreen extends StatefulWidget {
  const VanshavaliScreen({super.key});

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

  Future<void> _checkForRemoteUpdates() async {
    // Get the latest lastUpdated from Firestore
    final snapshot =
        await FirebaseFirestore.instance
            .collection('familyMembers')
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
        final box = Hive.box<FamilyMember>('familyBox');
        DateTime? localTime;
        for (var member in box.values) {
          if (member is FamilyMember && member.lastUpdated != null) {
            final t = member.lastUpdated!;
            if (localTime == null || t.isAfter(localTime)) {
              localTime = t;
            }
          }
        }
        setState(() {
          _localLastUpdated = localTime;
          _showUpdateBanner =
              localTime == null || remoteTime.isAfter(localTime);
        });
      }
    }
  }

  Future<void> _loadFamilyData({bool forceRefresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final box = Hive.box<FamilyMember>('familyBox');
      List<FamilyMember> data = [];
      if (!forceRefresh && box.isNotEmpty) {
        data = box.values.toList();
      } else {
        data = await fetchFamilyMembers();
        await box.clear();
        for (var member in data) {
          await box.put(member.id, member);
        }
      }
      if (data.isNotEmpty) {
        for (var root in data.where((m) => m.parentId == null)) {
          buildFamilyTreeFromFlatData(data, root.id);
        }
        setState(() {
          _familyData = data;
          _currentMember = data.firstWhere((m) => m.parentId == null);
          _loading = false;
        });
        // Update local lastUpdated
        DateTime? localTime;
        for (var member in data) {
          if (member.lastUpdated != null) {
            if (localTime == null || member.lastUpdated!.isAfter(localTime)) {
              localTime = member.lastUpdated!;
            }
          }
        }
        setState(() {
          _localLastUpdated = localTime;
        });
      } else {
        setState(() {
          _error = 'No family data found.';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _loading = false;
      });
    }
    // After loading, check for remote updates again
    _checkForRemoteUpdates();
  }

  Future<void> _refreshFromFirebase() async {
    await _loadFamilyData(forceRefresh: true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Family data refreshed from Firebase!')),
    );
    setState(() {
      _showUpdateBanner = false;
    });
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

  void _showSearchDialog() async {
    if (_familyData == null) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder:
          (context) => SearchDialog(
            familyData: _familyData!,
            onMemberSelected: (member) => _navigateToMember(member),
          ),
    );
  }

  void _showMemberDetails(FamilyMember member) {
    if (_familyData == null) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
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
          collectionName: 'familyMembers',
          onSaved: () async {
            await _loadFamilyData();
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
          collectionName: 'familyMembers',
          onSaved: () async {
            await _loadFamilyData();
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
          collectionName: 'familyMembers',
          onDeleted: () async {
            await _loadFamilyData();
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
    bool _fetchingBanner = false;
    // Remove modal dialog logic
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_familyData == null || _currentMember == null) {
      return const Center(child: Text('No data available.'));
    }
    final totalMembers = _familyData!.length;
    final double horizontalPadding = 12 + 12;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(240),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
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
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orange.shade300,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Family data has changed. Please get the latest data.',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 10),
                              _fetchingBanner
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.orange,
                                    ),
                                  )
                                  : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setBannerState(
                                        () => _fetchingBanner = true,
                                      );
                                      await _refreshFromFirebase();
                                      setBannerState(
                                        () => _fetchingBanner = false,
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
                    onSearchPressed: _showSearchDialog,
                    heading: 'Vanshavali',
                    hindiHeading: '(वंशावली - परिवार वृक्ष)',
                  ),
                  if (userAuth.isAdmin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.green),
                          onPressed: _refreshFromFirebase,
                          color: Colors.green[700],
                          tooltip: 'Refresh',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double contentWidth = screenWidth - horizontalPadding;
          final double maxContentWidth = 900;
          final double cardWidth =
              contentWidth > maxContentWidth ? maxContentWidth : contentWidth;
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
                        margin: const EdgeInsets.only(top: 8, bottom: 18),
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.green[200]!,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
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
                      SizedBox(
                        width: cardWidth,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.green.shade100,
                              width: 2,
                            ),
                            foregroundColor: Colors.green.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MoreFamilyScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'View More Vanshavali',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
