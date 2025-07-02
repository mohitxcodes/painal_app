import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';

class FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onTap;

  const FamilyMemberCard({Key? key, required this.member, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                'Born: \\${member.birthYear}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 18), // Space for navigation button
            ],
          ),
        ),
      ),
    );
  }
}
