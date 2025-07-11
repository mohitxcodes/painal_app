import 'package:flutter/material.dart';

class VanshavaliHeader extends StatelessWidget {
  final int totalMembers;
  final VoidCallback onSearchPressed;

  const VanshavaliHeader({
    super.key,
    required this.totalMembers,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              ' $totalMembers',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.search,
                size: 26,
                color: Colors.green,
                weight: 900,
              ),
              onPressed: onSearchPressed,
              tooltip: 'Search Family Member',
            ),
          ],
        ),
        const SizedBox(height: 0),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
      ],
    );
  }
}
