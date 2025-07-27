import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:painal/models/FamilyMember.dart';
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
  const FamilyTreeScreen({
    super.key,
    required this.collectionName,
    required this.heading,
    required this.hindiHeading,
    required this.totalMembers,
    required this.onSearchPressed,
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

      final snapshot = await FirebaseFirestore.instance
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
    return Scaffold(
      appBar: AppBar(title: const Text('Family Tree')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VanshavaliHeader(
              onSearchPressed: widget.onSearchPressed,
              totalMembers: widget.totalMembers,
              heading: widget.heading,
              hindiHeading: widget.hindiHeading,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: cardWidth,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green[200]!, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
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
            ),
          ],
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
