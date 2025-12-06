import 'package:flutter/material.dart';

class VanshavaliHeader extends StatelessWidget {
  final int totalMembers;
  final VoidCallback onSearchPressed;
  final String heading;
  final String hindiHeading;

  const VanshavaliHeader({
    super.key,
    required this.heading,
    required this.hindiHeading,
    required this.totalMembers,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        heading,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hindiHeading,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'Trace your lineage, celebrate stories',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                color: Colors.white.withOpacity(0.18),
              ),
              child: IconButton(
                onPressed: onSearchPressed,
                tooltip: 'Search Family Member',
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
