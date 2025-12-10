import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/widgets/search_dialog.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_body.dart';
import 'package:painal/screens/vanshavali/widgets/add_member_drawer.dart';
import 'package:painal/screens/vanshavali/widgets/edit_member_drawer.dart';
import 'package:painal/screens/vanshavali/widgets/delete_confirmation_dialog.dart';
import 'package:painal/screens/vanshavali/widgets/MemberInfoDrawer.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_header.dart';

class FamilyTreeScreen extends StatefulWidget {
  final String collectionName;
  final int totalMembers;
  final String heading;
  final String hindiHeading;
  final VoidCallback onSearchPressed;
  final int? initialMemberId;
  const FamilyTreeScreen({
    super.key,
    required this.collectionName,
    required this.heading,
    required this.hindiHeading,
    required this.totalMembers,
    required this.onSearchPressed,
    this.initialMemberId,
  });

  @override
  State<FamilyTreeScreen> createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  List<FamilyMember>? _familyData;
  FamilyMember? _currentMember;
  final List<FamilyMember> _navigationStack = [];
  bool _loading = true;
  late final String _boxName;
  String? _error;

  @override
  void initState() {
    super.initState();
    _boxName = 'familyBox_${widget.collectionName}';
    _loadFamilyData();
  }

  Future<void> _loadFamilyData({bool forceRefresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final box = await Hive.openBox<FamilyMember>(_boxName);

      if (!forceRefresh && box.isNotEmpty) {
        final data = box.values.toList();
        for (var root in data.where((m) => m.parentId == null)) {
          buildFamilyTreeFromFlatData(data, root.id);
        }
        setState(() {
          _familyData = data;
          _currentMember = data.firstWhere((m) => m.parentId == null);
          _loading = false;
        });
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .get();
      final data =
          snapshot.docs.map((doc) => FamilyMember.fromMap(doc.data())).toList();
      if (data.isNotEmpty) {
        for (var root in data.where((m) => m.parentId == null)) {
          buildFamilyTreeFromFlatData(data, root.id);
        }
        await box.clear();
        for (var member in data) {
          await box.put(member.id, member);
        }
        setState(() {
          _familyData = data;
          _currentMember = data.firstWhere((m) => m.parentId == null);
          _loading = false;
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

    // Handle deep link if requested
    if (widget.initialMemberId != null &&
        !forceRefresh &&
        _familyData != null) {
      try {
        final targetMember = _familyData!.firstWhere(
          (m) => m.id == widget.initialMemberId,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToMember(targetMember);
          _showMemberDetails(targetMember);
        });
      } catch (_) {
        // Member not found in list
      }
    }
  }

  void _navigateToChild(FamilyMember child) {
    setState(() {
      _navigationStack.add(_currentMember!);
      _currentMember = child;
    });
  }

  void _navigateToMember(FamilyMember member) {
    if (_familyData == null) return;
    List<FamilyMember> stack = [];
    FamilyMember? current = member;

    // Build stack from child to root
    while (current?.parentId != null) {
      final parent = _familyData!.firstWhere(
        (m) => m.id == current!.parentId,
        orElse: () => current!,
      );
      if (parent.id == current!.id) break; // Breaker for circular or root
      stack.insert(0, parent);
      current = parent;
    }

    // Update state to navigate
    setState(() {
      _navigationStack
        ..clear()
        ..addAll(stack);
      _currentMember = member;
    });
  }

  void _showSearchDialog() {
    if (_familyData == null || _familyData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No family data available for search.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder:
          (context) => SearchDialog(
            familyData: _familyData,
            onMemberSelected: (member) {
              Navigator.of(context).pop(); // Close dialog
              _navigateToMember(member);
            },
          ),
    );
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _currentMember = _navigationStack.removeLast();
      });
    }
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
          familyData: _familyData ?? <FamilyMember>[],
          collectionName: widget.collectionName,
          onSaved: () => _loadFamilyData(forceRefresh: true),
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
          onSaved: () => _loadFamilyData(forceRefresh: true),
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
          onDeleted: () => _loadFamilyData(forceRefresh: true),
        );
      },
    );
  }

  void _showMemberDetails(FamilyMember member) {
    if (_familyData == null || _familyData!.isEmpty) return;
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
            ? (_familyData ?? <FamilyMember>[])
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Family Tree')),
        body: Center(child: Text(_error!)),
      );
    }
    if (_familyData == null || _currentMember == null) {
      return const Scaffold(body: Center(child: Text('No data available.')));
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = 12 + 12;
    final double contentWidth = screenWidth - horizontalPadding;
    final double maxContentWidth = 900;
    final double cardWidth =
        contentWidth > maxContentWidth ? maxContentWidth : contentWidth;

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: VanshavaliHeader(
                totalMembers: widget.totalMembers,
                heading: widget.heading,
                hindiHeading: widget.hindiHeading,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
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
  }
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
