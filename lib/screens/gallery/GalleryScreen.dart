import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        final galleryItems = [
          {
            'title': 'Village Landscape',
            'icon': Icons.landscape,
            'color': Colors.green,
          },
          {
            'title': 'Local Market',
            'icon': Icons.store,
            'color': Colors.orange,
          },
          {'title': 'Schools', 'icon': Icons.school, 'color': Colors.blue},
          {
            'title': 'Transport',
            'icon': Icons.directions_bus,
            'color': Colors.purple,
          },
          {
            'title': 'Agriculture',
            'icon': Icons.agriculture,
            'color': Colors.brown,
          },
          {'title': 'Community', 'icon': Icons.people, 'color': Colors.teal},
        ];

        return Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${galleryItems[index]['title']} - Coming Soon!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  galleryItems[index]['icon'] as IconData,
                  size: 50,
                  color: galleryItems[index]['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  galleryItems[index]['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
