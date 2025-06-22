import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

class FamilyMember {
  final int id;
  final String name;
  final String hindiName;
  final String birthYear;
  final List<int> children;
  final int? parentId;
  final String profilePhoto;
  List<FamilyMember> childMembers = [];

  FamilyMember({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.birthYear,
    required this.children,
    this.parentId,
    required this.profilePhoto,
  });
}

final List<FamilyMember> flatFamilyData = [
  FamilyMember(
    id: 1,
    name: "Raja Ram Ray",
    hindiName: "राजा राम राय",
    birthYear: "Unavailable",
    children: [2],
    profilePhoto: "",
  ),
  FamilyMember(
    id: 2,
    name: "Unknown1",
    hindiName: "अज्ञात1",
    birthYear: "Unavailable",
    children: [3, 4, 5],
    parentId: 1,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 3,
    name: "Rajman Ray",
    hindiName: "राजमन राय",
    birthYear: "Unavailable",
    children: [6],
    parentId: 2,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 4,
    name: "Unknown2",
    hindiName: "अज्ञात2",
    birthYear: "Unavailable",
    children: [],
    parentId: 2,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 5,
    name: "Balchan Ray",
    hindiName: "बलचन राय",
    birthYear: "Unavailable",
    children: [],
    parentId: 2,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 6,
    name: "Ranjit Singh",
    hindiName: "रणजीत सिंह",
    birthYear: "Unavailable",
    children: [7],
    parentId: 3,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 7,
    name: "Harlal Singh",
    hindiName: "हरलाल सिंह",
    birthYear: "Unavailable",
    children: [8, 9],
    parentId: 6,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 8,
    name: "Ratan Singh",
    hindiName: "रतन सिंह",
    birthYear: "Unavailable",
    children: [10, 11, 12, 13],
    parentId: 7,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 9,
    name: "Raguvar Singh",
    hindiName: "रागुवर सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 7,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 10,
    name: "Ramnewaj Singh",
    hindiName: "रामनवाज सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 8,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 11,
    name: "Ayodhaja Singh",
    hindiName: "अयोधाजा सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 8,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 12,
    name: "Ramweshar Singh",
    hindiName: "रामवेशर सिंह",
    birthYear: "Unavailable",
    children: [14],
    parentId: 8,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 13,
    name: "Rambhajan Singh",
    hindiName: "रामभजन सिंह",
    birthYear: "Unavailable",
    children: [15, 16, 17],
    parentId: 8,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 14,
    name: "Pardeep Singh",
    hindiName: "परदीप सिंह",
    birthYear: "Unavailable",
    children: [18, 19],
    parentId: 12,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 15,
    name: "Palak Singh",
    hindiName: "पलक सिंह",
    birthYear: "Unavailable",
    children: [20],
    parentId: 13,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 16,
    name: "Ganpati Singh",
    hindiName: "गणपति सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 13,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 17,
    name: "Jeetwhan Singh",
    hindiName: "जीतवान सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 13,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 18,
    name: "Rambrij Singh",
    hindiName: "रामबृज सिंह",
    birthYear: "Unavailable",
    children: [21, 22],
    parentId: 14,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 19,
    name: "Shivlal Singh",
    hindiName: "शिवलाल सिंह",
    birthYear: "Unavailable",
    children: [23, 24, 25, 26, 27],
    parentId: 14,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 20,
    name: "Bahadur Singh",
    hindiName: "बहादुर सिंह",
    birthYear: "Unavailable",
    children: [28],
    parentId: 15,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 21,
    name: "Chandeo Singh",
    hindiName: "चंदेओ सिंह",
    birthYear: "Unavailable",
    children: [29],
    parentId: 18,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 22,
    name: "Dhariskshan Singh",
    hindiName: "धरिक्षण सिंह",
    birthYear: "Unavailable",
    children: [30, 31],
    parentId: 18,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 23,
    name: "Baiju Singh",
    hindiName: "बैजू सिंह",
    birthYear: "Unavailable",
    children: [32, 33, 34, 35],
    parentId: 19,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 24,
    name: "Awadesh Singh",
    hindiName: "अवधेश सिंह",
    birthYear: "Unavailable",
    children: [36],
    parentId: 19,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 25,
    name: "Narseh Singh",
    hindiName: "नरसह सिंह",
    birthYear: "Unavailable",
    children: [37, 38],
    parentId: 19,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 26,
    name: "Suresh Singh",
    hindiName: "सुरेश सिंह",
    birthYear: "Unavailable",
    children: [39, 40, 41],
    parentId: 19,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 27,
    name: "Umesh Singh",
    hindiName: "उमेश सिंह",
    birthYear: "Unavailable",
    children: [42],
    parentId: 19,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 28,
    name: "Jitendar Singh",
    hindiName: "जितेंदर सिंह",
    birthYear: "Unavailable",
    children: [],
    parentId: 20,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 29,
    name: "Akhilesh Singh",
    hindiName: "अखिलेश सिंह",
    birthYear: "Unavailable",
    children: [43, 44],
    parentId: 21,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 30,
    name: "Abhey Shankar",
    hindiName: "अभय शंकर",
    birthYear: "Unavailable",
    children: [45, 46],
    parentId: 22,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 31,
    name: "Udhay Shankar",
    hindiName: "उदय शंकर",
    birthYear: "Unavailable",
    children: [47],
    parentId: 22,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 32,
    name: "Rangnath Singh",
    hindiName: "रंगनाथ सिंह",
    birthYear: "Unavailable",
    children: [48],
    parentId: 23,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 33,
    name: "Jagnath Singh",
    hindiName: "जगनाथ सिंह",
    birthYear: "Unavailable",
    children: [49, 50],
    parentId: 23,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 34,
    name: "Binay Kumar",
    hindiName: "बिनय कुमार",
    birthYear: "Unavailable",
    children: [51],
    parentId: 23,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 35,
    name: "Bipin Kumar",
    hindiName: "बिपिन कुमार",
    birthYear: "Unavailable",
    children: [52, 53],
    parentId: 23,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 36,
    name: "Ravi Nandan",
    hindiName: "रवि नंदन",
    birthYear: "Unavailable",
    children: [54, 55],
    parentId: 24,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 37,
    name: "Prenath Singh",
    hindiName: "प्रेमनाथ सिंह",
    birthYear: "Unavailable",
    children: [56, 57],
    parentId: 25,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 38,
    name: "Priyanath Singh",
    hindiName: "प्रियनाथ सिंह",
    birthYear: "Unavailable",
    children: [58],
    parentId: 25,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 39,
    name: "Sambhu Nath",
    hindiName: "शंभू नाथ",
    birthYear: "Unavailable",
    children: [55],
    parentId: 26,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 40,
    name: "Sankar Nath",
    hindiName: "शंकर नाथ",
    birthYear: "Unavailable",
    children: [59],
    parentId: 26,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 41,
    name: "Sasi Bhushan",
    hindiName: "सासी भूषण",
    birthYear: "Unavailable",
    children: [60],
    parentId: 26,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 42,
    name: "Sabhajeet Kumar",
    hindiName: "सभाजीत कुमार",
    birthYear: "Unavailable",
    children: [61],
    parentId: 27,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 43,
    name: "Aditya Kumar",
    hindiName: "आदित्य कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 29,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 44,
    name: "Bhashkar",
    hindiName: "भास्कर",
    birthYear: "Unavailable",
    children: [],
    parentId: 29,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 45,
    name: "Aniket Kumar",
    hindiName: "अनिकेत कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 30,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 46,
    name: "Anurag Bhaskar",
    hindiName: "अनुराग भास्कर",
    birthYear: "Unavailable",
    children: [],
    parentId: 30,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 47,
    name: "Rishikesh Kumar",
    hindiName: "ऋषिकेश कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 31,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 48,
    name: "Nitiesh Kumar",
    hindiName: "नितीश कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 32,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 49,
    name: "Amarnath",
    hindiName: "अमरनाथ",
    birthYear: "Unavailable",
    children: [],
    parentId: 33,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 50,
    name: "Samar Nath",
    hindiName: "समर नाथ",
    birthYear: "Unavailable",
    children: [],
    parentId: 33,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 51,
    name: "Ritik Kumar",
    hindiName: "रितिक कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 34,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 52,
    name: "Rajnish Kumar",
    hindiName: "रजनीश कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 35,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 53,
    name: "Awnish Kumar",
    hindiName: "अवनीश कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 35,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 54,
    name: "Papu Kumar",
    hindiName: "पप्पू कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 36,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 55,
    name: "Abhishek Kumar",
    hindiName: "अभिषेक कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 39,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 56,
    name: "Pankaj Kumar",
    hindiName: "पंकज कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 37,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 57,
    name: "Santosh Kumar",
    hindiName: "संतोष कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 37,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 58,
    name: "Suraykant Kumar",
    hindiName: "सूर्यकांत कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 38,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 59,
    name: "Rohit Kumar",
    hindiName: "रोहित कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 40,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 60,
    name: "Ashutosh Kumar",
    hindiName: "आशुतोष कुमार",
    birthYear: "Unavailable",
    children: [],
    parentId: 41,
    profilePhoto: "",
  ),
  FamilyMember(
    id: 61,
    name: "Mohit Kumar",
    hindiName: "मोहित कुमार",
    birthYear: "2006",
    children: [],
    parentId: 42,
    profilePhoto: "family-img/mohit-family/mohit.jpeg",
  ),
];

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

// Build the tree structure before using it
void _prepareFamilyTree() {
  for (var root in flatFamilyData.where((m) => m.parentId == null)) {
    buildFamilyTreeFromFlatData(flatFamilyData, root.id);
  }
}

class VanshavaliScreen extends StatefulWidget {
  const VanshavaliScreen({super.key});

  @override
  State<VanshavaliScreen> createState() => _VanshavaliScreenState();
}

class _VanshavaliScreenState extends State<VanshavaliScreen> {
  late FamilyMember _currentMember;
  final List<FamilyMember> _navigationStack = [];

  @override
  void initState() {
    super.initState();
    _prepareFamilyTree();
    // Start with the first root
    _currentMember = flatFamilyData.firstWhere((m) => m.parentId == null);
  }

  void _navigateToChild(FamilyMember child) {
    setState(() {
      _navigationStack.add(_currentMember);
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
    // Build the navigation stack to this member
    List<FamilyMember> stack = [];
    FamilyMember? current = member;
    while (current?.parentId != null) {
      final parent = flatFamilyData.firstWhere(
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
                      flatFamilyData
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
                                                    ? flatFamilyData.firstWhere(
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
    final totalMembers = flatFamilyData.length;
    final totalGenerations = _calculateGenerations();
    final double horizontalPadding =
        12 + 12; // from EdgeInsets.fromLTRB(12, ...)
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(240),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
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
                            Text(
                              'Vanshavali - Family Tree',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
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
                            Text(
                              'Explore your family lineage and discover connections across generations. Use the search to quickly find any member.',
                              style: const TextStyle(
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
                      Text(
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
                      Text(
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
                              child: _familyMemberCard(_currentMember),
                            ),
                            if (_currentMember.childMembers.isNotEmpty) ...[
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
                                      _currentMember.childMembers.map((child) {
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
    final parent =
        member.parentId != null
            ? flatFamilyData.firstWhere(
              (m) => m.id == member.parentId,
              orElse: () => member,
            )
            : null;
    final children = member.childMembers;
    final siblings =
        member.parentId != null
            ? flatFamilyData
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
                                  'जन्म वर्ष: ${member.birthYear}',
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

  int _calculateGenerations() {
    // Implementation of _calculateGenerations method
    // This is a placeholder and should be replaced with the actual implementation
    return 0; // Placeholder return, actual implementation needed
  }
}
