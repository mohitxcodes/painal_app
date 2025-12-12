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

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
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

      if (mounted) {
        setState(() {
          _familyData = data;
          _currentMember = rootMembers.first;
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
  }

  Future<void> _refreshFromFirebase() async {
    await _loadFamilyData(forceRefresh: true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Family data refreshed!'),
          backgroundColor: Colors.green,
        ),
      );
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
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
              Navigator.of(context).pop();
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
                child: VanshavaliHeader(
                  totalMembers: totalMembers,
                  heading: widget.heading,
                  hindiHeading: widget.hindiHeading,
                  onRefresh: _refreshFromFirebase,
                  showRefresh: userAuth.isAdmin,
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
