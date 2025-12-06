import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';

class FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onTap;

  const FamilyMemberCard({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.22), width: 1.2),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.18),
              Colors.white.withOpacity(0.07),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage:
                    member.profilePhoto.isNotEmpty
                        ? NetworkImage(member.profilePhoto)
                        : null,
                child:
                    member.profilePhoto.isEmpty
                        ? const Icon(
                          Icons.person,
                          color: Colors.white,
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
                  color: Colors.white,
                ),
              ),
              Text(
                member.name,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'Born: ${member.birthYear}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 18), // Space for navigation button
            ],
          ),
        ),
      ),
    );
  }
}
