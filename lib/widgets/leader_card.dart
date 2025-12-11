import 'package:flutter/material.dart';
import 'package:painal/models/political_leader.dart';

class LeaderCard extends StatelessWidget {
  final PoliticalLeader leader;

  const LeaderCard({super.key, required this.leader});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      color: const Color(0xFF1A4B3D),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leader's Avatar with fallback
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.1),
              backgroundImage:
                  leader.imageUrl.isNotEmpty
                      ? NetworkImage(leader.imageUrl)
                      : null,
              child:
                  leader.imageUrl.isEmpty
                      ? const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white70,
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            // Leader's Details
            Expanded(
              child: Column(
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
                              leader.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (leader.englishName.isNotEmpty)
                              Text(
                                leader.englishName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Position Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              leader.position == 'मुखिया'
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                leader.position == 'मुखिया'
                                    ? Colors.orange.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          leader.position,
                          style: TextStyle(
                            color:
                                leader.position == 'मुखिया'
                                    ? Colors.orange[300]
                                    : Colors.green[300],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        leader.tenure,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
