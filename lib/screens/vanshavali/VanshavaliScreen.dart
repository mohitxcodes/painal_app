import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:painal/data/FamilyData.dart';
import 'package:painal/data/FamilyData.dart';
import 'dart:ui';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/apis/UploadImage.dart';

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
    // uploadInitialData();
  }

  Future<void> _loadFamilyData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await fetchFamilyMembers();
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
                      _familyData!
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
                // Blur background
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
                                                    ? _familyData!.firstWhere(
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
                                                radius: 22,
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
                                                        'Parent: ${parent.name}',
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
      return Center(child: Text(_error!));
    }
    if (_familyData == null || _currentMember == null) {
      return const Center(child: Text('No data available.'));
    }
    final totalMembers = _familyData!.length;
    final double horizontalPadding =
        12 + 12; // from EdgeInsets.fromLTRB(12, ...)
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Vanshavali',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '(वंशावली - परिवार वृक्ष)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                                letterSpacing: 0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total Members: ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$totalMembers',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 8),
                      // Search icon button (right)
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 26, // Increased size for more boldness
                          color: Colors.green,
                          weight:
                              900, // Flutter 3.10+ supports weight for MaterialIcons
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
              width: screenWidth, // Take full width for centering
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width: cardWidth,
                    margin: const EdgeInsets.only(top: 8, bottom: 18),
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      10,
                      10,
                      20,
                    ), // extra bottom padding for navigation button
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
                            // Main member card always full width
                            SizedBox(
                              width: contentInnerWidth,
                              child: _familyMemberCard(_currentMember!),
                            ),
                            if (_currentMember!.childMembers.isNotEmpty) ...[
                              // Draw vertical line
                              Container(
                                width: 2,
                                height: 32,
                                color: Colors.green[200],
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                              // Children row scrollable inside the bordered area
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
                                                          }, // Disabled navigation
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
              const SizedBox(height: 10),
              Text(
                member.hindiName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Text(
                member.name,
                style: const TextStyle(fontSize: 13, color: Colors.green),
              ),
              Text(
                'Born: ${member.birthYear}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 18), // Space for navigation button
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDetails(FamilyMember member) {
    if (_familyData == null) return;
    // Close any previous drawer before opening a new one
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.hindiName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            member.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Text(
                                            'जन्म वर्ष: ${member.birthYear}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        // TODO: Implement report functionality
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red[700],
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 0,
                                        ),
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      icon: const Icon(
                                        Icons.report_gmailerrorred_outlined,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      label: const Text('Report'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: const Icon(Icons.edit, size: 20),
                              label: const Text('Edit'),
                              onPressed: () {
                                _showEditMemberDrawer(member);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green[400],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 22,
                              ),
                              label: const Text('Add'),
                              onPressed: () {
                                _showAddMemberDrawer(member);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline, size: 22),
                          label: const Text('Delete'),
                          onPressed: () {
                            _showDeleteConfirmation(member);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (parent != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Father',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '(पिता)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _memberRectCard(parent),
                            const SizedBox(height: 18),
                          ],
                        ),
                      if (children.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Children',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '(बच्चे)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: children.map(_memberRectCard).toList(),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      if (siblings.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Siblings',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '(भाई-बहन)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: siblings.map(_memberRectCard).toList(),
                            ),
                            const SizedBox(height: 18),
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

  Widget _memberRectCard(FamilyMember member) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showMemberDetails(member),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFFF9FAFB), // subtle off-white
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green[100]!, width: 1.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            size: 22,
                          )
                          : null,
                ),
                const SizedBox(width: 18),
                Container(width: 1.5, height: 38, color: Colors.green[50]),
                const SizedBox(width: 18),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.hindiName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      if (member.birthYear.isNotEmpty)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'DOB: ${member.birthYear}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
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
    );
  }

  void _showEditMemberDrawer(FamilyMember member) {
    final nameController = TextEditingController(text: member.name);
    final hindiNameController = TextEditingController(text: member.hindiName);
    final dobController = TextEditingController(text: member.birthYear);
    String? uploadedPhotoUrl = member.profilePhoto;
    bool loading = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.green[100],
                          backgroundImage:
                              (uploadedPhotoUrl != null &&
                                      uploadedPhotoUrl?.isNotEmpty == true)
                                  ? NetworkImage(uploadedPhotoUrl ?? '')
                                  : null,
                          child:
                              (uploadedPhotoUrl == null ||
                                      uploadedPhotoUrl?.isEmpty != false)
                                  ? const Icon(
                                    Icons.person,
                                    color: Colors.green,
                                    size: 38,
                                  )
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder:
                                      (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                );
                                final url = await pickAndUploadImage();
                                Navigator.of(context).pop();
                                if (url != null && url.isNotEmpty) {
                                  setState(() {
                                    uploadedPhotoUrl = url;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Profile photo uploaded!'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Image upload failed.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Edit Member',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: hindiNameController,
                    decoration: InputDecoration(
                      labelText: 'Hindi Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: dobController,
                    decoration: InputDecoration(
                      labelText: 'Birth Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          loading
                              ? null
                              : () async {
                                setState(() => loading = true);
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('familyMembers')
                                      .doc(member.id.toString())
                                      .update({
                                        'name': nameController.text.trim(),
                                        'hindiName':
                                            hindiNameController.text.trim(),
                                        'birthYear': dobController.text.trim(),
                                        'profilePhoto': uploadedPhotoUrl ?? '',
                                      });
                                  if (context.mounted) {
                                    // Close all open drawers/dialogs
                                    Navigator.of(
                                      context,
                                    ).popUntil((route) => route.isFirst);
                                    await _loadFamilyData();

                                    // Navigate to the edited member's family tree
                                    final editedMemberInData = _familyData
                                        ?.firstWhere(
                                          (m) => m.id == member.id,
                                          orElse: () => _familyData!.first,
                                        );

                                    if (editedMemberInData != null) {
                                      // Build navigation stack to reach the edited member
                                      _navigateToMember(editedMemberInData);
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Member updated successfully!',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to update: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } finally {
                                  if (context.mounted)
                                    setState(() => loading = false);
                                }
                              },
                      child:
                          loading
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                              : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddMemberDrawer(FamilyMember parent) {
    final nameController = TextEditingController();
    final hindiNameController = TextEditingController();
    final dobController = TextEditingController();
    final profilePhotoController = TextEditingController();
    String? uploadedPhotoUrl;
    bool loading = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.green[100],
                          backgroundImage:
                              (uploadedPhotoUrl != null &&
                                      uploadedPhotoUrl!.isNotEmpty)
                                  ? NetworkImage(uploadedPhotoUrl!)
                                  : null,
                          child:
                              (uploadedPhotoUrl == null ||
                                      uploadedPhotoUrl!.isEmpty)
                                  ? const Icon(
                                    Icons.person,
                                    color: Colors.green,
                                    size: 38,
                                  )
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder:
                                      (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                );
                                final url = await pickAndUploadImage();
                                Navigator.of(context).pop();
                                if (url != null && url.isNotEmpty) {
                                  setState(() {
                                    uploadedPhotoUrl = url;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Profile photo uploaded!'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Image upload failed.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add Family Member',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: hindiNameController,
                    decoration: InputDecoration(
                      labelText: 'Hindi Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: dobController,
                    decoration: InputDecoration(
                      labelText: 'Birth Year (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          loading
                              ? null
                              : () async {
                                final name = nameController.text.trim();
                                final hindiName =
                                    hindiNameController.text.trim();
                                final dob =
                                    dobController.text.trim().isEmpty
                                        ? 'Unavailable'
                                        : dobController.text.trim();
                                final profilePhoto = uploadedPhotoUrl ?? '';
                                if (name.isEmpty || hindiName.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Name and Hindi Name are required.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                setState(() => loading = true);
                                try {
                                  // Find max id in _familyData
                                  int maxId = 0;
                                  if (_familyData != null &&
                                      _familyData!.isNotEmpty) {
                                    maxId = _familyData!
                                        .map((m) => m.id)
                                        .reduce((a, b) => a > b ? a : b);
                                  }
                                  final newId = maxId + 1;
                                  await FirebaseFirestore.instance
                                      .collection('familyMembers')
                                      .doc(newId.toString())
                                      .set({
                                        'id': newId,
                                        'name': name,
                                        'hindiName': hindiName,
                                        'birthYear': dob,
                                        'children': <int>[],
                                        'parentId': parent.id,
                                        'profilePhoto': profilePhoto,
                                      });
                                  // Update parent's children list
                                  final updatedChildren = List<int>.from(
                                    parent.children,
                                  )..add(newId);
                                  await FirebaseFirestore.instance
                                      .collection('familyMembers')
                                      .doc(parent.id.toString())
                                      .update({'children': updatedChildren});
                                  if (context.mounted) {
                                    // Close all open drawers/dialogs
                                    Navigator.of(
                                      context,
                                    ).popUntil((route) => route.isFirst);
                                    await _loadFamilyData();

                                    // Navigate to the parent tree of the added member
                                    final parentInData = _familyData
                                        ?.firstWhere(
                                          (m) => m.id == parent.id,
                                          orElse: () => _familyData!.first,
                                        );

                                    if (parentInData != null) {
                                      // Build navigation stack to reach the parent
                                      _navigateToMember(parentInData);
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Member added successfully!',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to add: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } finally {
                                  if (context.mounted)
                                    setState(() => loading = false);
                                }
                              },
                      child:
                          loading
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                              : const Text(
                                'Add Member',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text('Confirm Deletion'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${member.name}"?\nThis action cannot be undone.',
            style: const TextStyle(fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteMember(member);
              },
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMember(FamilyMember member) async {
    try {
      // Remove member from Firestore
      await FirebaseFirestore.instance
          .collection('familyMembers')
          .doc(member.id.toString())
          .delete();
      // Remove from parent's children list if parent exists
      if (member.parentId != null) {
        final parentDoc =
            await FirebaseFirestore.instance
                .collection('familyMembers')
                .doc(member.parentId.toString())
                .get();
        if (parentDoc.exists) {
          final parentData = parentDoc.data()!;
          final List<dynamic> children = List.from(
            parentData['children'] ?? [],
          );
          children.remove(member.id);
          await FirebaseFirestore.instance
              .collection('familyMembers')
              .doc(member.parentId.toString())
              .update({'children': children});
        }
      }
      if (context.mounted) {
        // Close all drawers
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member deleted successfully!')),
        );
        _loadFamilyData();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
