import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'package:painal/models/FamilyMember.dart';

Future<List<FamilyMember>> fetchFamilyMembers() async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('familyMembers')
          .orderBy('id')
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
  late List<FamilyMember> _familyData;
  FamilyMember? _currentMember;
  final List<FamilyMember> _navigationStack = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
  }

  Future<void> _loadFamilyData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await fetchFamilyMembers();
      if (data.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No family data found.';
        });
        return;
      }
      for (var root in data.where((m) => m.parentId == null)) {
        buildFamilyTreeFromFlatData(data, root.id);
      }
      setState(() {
        _familyData = data;
        _currentMember = data.firstWhere((m) => m.parentId == null);
        _navigationStack.clear();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load data: \$e';
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

  void _navigateToMember(FamilyMember member) {
    List<FamilyMember> stack = [];
    FamilyMember? current = member;
    while (current?.parentId != null) {
      final parent = _familyData.firstWhere(
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
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        String query = '';
        List<FamilyMember> results = [];
        return StatefulBuilder(
          builder: (context, setState) {
            void updateResults(String value) {
              setState(() {
                query = value;
                if (query.isEmpty) {
                  results = [];
                } else {
                  results =
                      _familyData
                          .where(
                            (m) =>
                                m.name.toLowerCase().contains(
                                  query.toLowerCase(),
                                ) ||
                                m.hindiName.contains(query),
                          )
                          .toList();
                }
              });
            }

            Widget _highlightText(
              String text,
              String query, {
              TextStyle? style,
              TextStyle? highlightStyle,
            }) {
              if (query.isEmpty) return Text(text, style: style);
              final lower = text.toLowerCase();
              final lowerQuery = query.toLowerCase();
              final spans = <TextSpan>[];
              int start = 0;
              int idx;
              while ((idx = lower.indexOf(lowerQuery, start)) != -1) {
                if (idx > start) {
                  spans.add(
                    TextSpan(text: text.substring(start, idx), style: style),
                  );
                }
                spans.add(
                  TextSpan(
                    text: text.substring(idx, idx + query.length),
                    style:
                        highlightStyle ??
                        const TextStyle(
                          backgroundColor: Color(0x33FFEB3B),
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
                start = idx + query.length;
              }
              if (start < text.length) {
                spans.add(TextSpan(text: text.substring(start), style: style));
              }
              return RichText(text: TextSpan(children: spans));
            }

            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.transparent),
                ),
                Center(
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    insetPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green.withOpacity(0.4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                          maxHeight: 440,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Search by name...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 14,
                                            ),
                                        isDense: true,
                                      ),
                                      onChanged: updateResults,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child:
                                    query.isEmpty
                                        ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.family_restroom,
                                                color: Colors.green[200],
                                                size: 48,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Start typing to search for a family member',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : results.isEmpty
                                        ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.sentiment_dissatisfied,
                                                color: Colors.grey[400],
                                                size: 40,
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'No family members found',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        : ListView.separated(
                                          itemCount: results.length,
                                          separatorBuilder:
                                              (_, __) => const Divider(
                                                height: 1,
                                                color: Color(0xFFE0E0E0),
                                              ),
                                          itemBuilder: (context, idx) {
                                            final member = results[idx];
                                            final parent =
                                                member.parentId != null
                                                    ? _familyData.firstWhere(
                                                      (m) =>
                                                          m.id ==
                                                          member.parentId,
                                                      orElse:
                                                          () => FamilyMember(
                                                            id: -1,
                                                            name: 'No parent',
                                                            hindiName: '',
                                                            birthYear: '',
                                                            children: [],
                                                            profilePhoto: '',
                                                          ),
                                                    )
                                                    : null;
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.green[100],
                                                backgroundImage:
                                                    member
                                                            .profilePhoto
                                                            .isNotEmpty
                                                        ? NetworkImage(
                                                          member.profilePhoto,
                                                        )
                                                        : null,
                                                child:
                                                    member.profilePhoto.isEmpty
                                                        ? const Icon(
                                                          Icons.person,
                                                          color: Colors.green,
                                                        )
                                                        : null,
                                              ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _highlightText(
                                                    member.name,
                                                    query,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  _highlightText(
                                                    member.hindiName,
                                                    query,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle:
                                                  parent != null &&
                                                          parent.id != -1
                                                      ? Text(
                                                        'Parent: \\${parent.name}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                        ),
                                                      )
                                                      : const Text(
                                                        'No parent',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black38,
                                                        ),
                                                      ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                _navigateToMember(member);
                                              },
                                            );
                                          },
                                        ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                bottom: 10,
                                top: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Material(
                                    color: Colors.green[700],
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 3),
                                            const Text(
                                              'Close',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadFamilyData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_currentMember == null) {
      return const Center(child: Text('No root member found.'));
    }
    final totalMembers = _familyData.length;
    final totalGenerations = _calculateGenerations(_familyData);
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vanshavali - Family Tree',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'वंशावली - परिवार वृक्ष',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                                letterSpacing: 0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Explore your family lineage and discover connections across generations. Use the search to quickly find any member.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      const Text(
                        'Total Members: ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$totalMembers',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'Generations: ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$totalGenerations',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.green,
                          size: 26,
                        ),
                        onPressed: _showSearchDialog,
                        tooltip: 'Search Family Member',
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
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
                    child: LayoutBuilder(
                      builder: (context, innerConstraints) {
                        final contentInnerWidth = innerConstraints.maxWidth;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_navigationStack.isNotEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: _navigateBack,
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black87,
                                  ),
                                  label: const Text(
                                    'Back',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: contentInnerWidth,
                              child: _familyMemberCard(_currentMember!),
                            ),
                            if (_currentMember!.childMembers.isNotEmpty) ...[
                              Container(
                                width: 2,
                                height: 32,
                                color: Colors.green[200],
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      _currentMember!.childMembers.map((child) {
                                        return Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            _familyMemberCard(child),
                                            Positioned(
                                              child:
                                                  child.childMembers.isNotEmpty
                                                      ? Material(
                                                        color:
                                                            Colors.green[700],
                                                        shape:
                                                            const CircleBorder(),
                                                        child: InkWell(
                                                          customBorder:
                                                              const CircleBorder(),
                                                          onTap:
                                                              () =>
                                                                  _navigateToChild(
                                                                    child,
                                                                  ),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  6.0,
                                                                ),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      : Material(
                                                        color: Colors.red[200],
                                                        shape:
                                                            const CircleBorder(),
                                                        child: InkWell(
                                                          customBorder:
                                                              const CircleBorder(),
                                                          onTap: () {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'No children for this member.',
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          2,
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  6.0,
                                                                ),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
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

  Widget _familyMemberCard(FamilyMember member) {
    return GestureDetector(
      onTap: () => _showMemberDetails(member),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[1],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.green[100]!, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.green[100],
                backgroundImage:
                    member.profilePhoto.isNotEmpty
                        ? NetworkImage(member.profilePhoto)
                        : null,
                child:
                    member.profilePhoto.isEmpty
                        ? const Icon(
                          Icons.person,
                          color: Colors.green,
                          size: 24,
                        )
                        : null,
              ),
              const SizedBox(height: 10),
              Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Text(
                member.hindiName,
                style: const TextStyle(fontSize: 13, color: Colors.green),
              ),
              Text(
                'Born: \\${member.birthYear}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDetails(FamilyMember member) {
    final parent =
        member.parentId != null
            ? _familyData.firstWhere(
              (m) => m.id == member.parentId,
              orElse: () => member,
            )
            : null;
    final children = member.childMembers;
    final siblings =
        member.parentId != null
            ? _familyData
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
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.green[100],
                            backgroundImage:
                                member.profilePhoto.isNotEmpty
                                    ? NetworkImage(member.profilePhoto)
                                    : null,
                            child:
                                member.profilePhoto.isEmpty
                                    ? const Icon(
                                      Icons.person,
                                      color: Colors.green,
                                      size: 28,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  member.hindiName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'जन्म वर्ष: \\${member.birthYear}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (parent != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parent:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _memberMiniCard(parent),
                            const SizedBox(height: 16),
                          ],
                        ),
                      if (siblings.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Siblings:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: siblings.map(_memberMiniCard).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      if (children.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Children:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: children.map(_memberMiniCard).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _memberMiniCard(FamilyMember member) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.green[100],
          backgroundImage:
              member.profilePhoto.isNotEmpty
                  ? NetworkImage(member.profilePhoto)
                  : null,
          child:
              member.profilePhoto.isEmpty
                  ? const Icon(Icons.person, color: Colors.green, size: 18)
                  : null,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            Text(
              member.hindiName,
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  int _calculateGenerations(List<FamilyMember> data) {
    // Calculate the max depth of the tree
    int maxDepth = 0;
    void dfs(FamilyMember member, int depth) {
      if (depth > maxDepth) maxDepth = depth;
      for (var child in member.childMembers) {
        dfs(child, depth + 1);
      }
    }

    for (var root in data.where((m) => m.parentId == null)) {
      dfs(root, 1);
    }
    return maxDepth;
  }
}
