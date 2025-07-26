import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/widgets/family_member_card.dart';

class MoreFamilyScreen extends StatelessWidget {
  const MoreFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final List<FamilyMember> members = [
      FamilyMember(
        id: 1,
        name: 'Amit',
        hindiName: 'अमित',
        birthYear: '1980',
        children: [],
        parentId: null,
        profilePhoto: '',
        lastUpdated: null,
      ),
      FamilyMember(
        id: 2,
        name: 'Sunita',
        hindiName: 'सुनीता',
        birthYear: '1982',
        children: [],
        parentId: null,
        profilePhoto: '',
        lastUpdated: null,
      ),
      FamilyMember(
        id: 3,
        name: 'Ravi',
        hindiName: 'रवि',
        birthYear: '2000',
        children: [],
        parentId: null,
        profilePhoto: '',
        lastUpdated: null,
      ),
      FamilyMember(
        id: 4,
        name: 'Priya',
        hindiName: 'प्रिया',
        birthYear: '2002',
        children: [],
        parentId: null,
        profilePhoto: '',
        lastUpdated: null,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Vanshavali'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            return FamilyMemberCard(member: members[index], onTap: () {});
          },
        ),
      ),
    );
  }
}
