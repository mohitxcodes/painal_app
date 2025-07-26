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

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
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

  void _refreshFromFirebase() async {
    await _loadFamilyData(forceRefresh: true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Family data refreshed from Firebase!')),
    );
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
                  VanshavaliHeader(
                    totalMembers: totalMembers,
                    onSearchPressed: _showSearchDialog,
                  ),
                  if (userAuth.isAdmin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh from Firebase'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _refreshFromFirebase,
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
                  child: Container(
                    width: cardWidth,
                    margin: const EdgeInsets.only(top: 8, bottom: 18),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.green[200]!, width: 1.2),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
