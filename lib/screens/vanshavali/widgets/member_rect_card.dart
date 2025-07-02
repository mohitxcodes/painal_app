import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';

class MemberRectCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onTap;

  const MemberRectCard({Key? key, required this.member, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
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
                              'DOB: \\${member.birthYear}',
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
}
