import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Vanshavali - Family Tree',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              if (_navigationStack.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _navigateBack,
                    icon: const Icon(Icons.arrow_back, color: Colors.green),
                    label: const Text(
                      'Back',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              _familyMemberCard(_currentMember),
              if (_currentMember.childMembers.isNotEmpty) ...[
                // Draw vertical line
                Container(
                  width: 2,
                  height: 32,
                  color: Colors.green[200],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _currentMember.childMembers.map((child) {
                        return Column(
                          children: [
                            _familyMemberCard(child),
                            TextButton.icon(
                              onPressed: () => _navigateToChild(child),
                              icon: const Icon(
                                Icons.arrow_downward,
                                size: 16,
                                color: Colors.green,
                              ),
                              label: const Text(
                                'Show Children',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _familyMemberCard(FamilyMember member) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green[100],
              backgroundImage:
                  member.profilePhoto.isNotEmpty
                      ? NetworkImage(member.profilePhoto)
                      : null,
              child:
                  member.profilePhoto.isEmpty
                      ? Text(
                        member.name.isNotEmpty ? member.name[0] : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      )
                      : null,
            ),
            const SizedBox(height: 8),
            Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
            Text(
              member.hindiName,
              style: const TextStyle(fontSize: 13, color: Colors.green),
            ),
            Text(
              'जन्म वर्ष: ${member.birthYear}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
