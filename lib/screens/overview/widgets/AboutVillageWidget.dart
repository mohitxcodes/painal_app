import 'package:flutter/material.dart';

class AboutVillageWidget extends StatelessWidget {
  const AboutVillageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.green.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.green[50]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and bilingual title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About Painal Village',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            'पैनाल गाँव के बारे में',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description without card wrapper
                const Text(
                  'Village Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Painal is a vibrant village located in Bihta Block of Patna District, Bihar. With a population of 9,618 people, it represents the rich cultural heritage and agricultural traditions of rural India.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The village is known for its strong community bonds, traditional festivals, and active participation in local governance.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Key features in a grid with bilingual text
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureItem(
                        Icons.people,
                        'Population',
                        'जनसंख्या',
                        '9,618',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeatureItem(
                        Icons.home,
                        'Houses',
                        'घर',
                        '1,601',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeatureItem(
                        Icons.school,
                        'Literacy',
                        'साक्षरता',
                        '60.3%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String labelEnglish,
    String labelHindi,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green[700], size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          Text(
            labelEnglish,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
          Text(
            labelHindi,
            style: TextStyle(fontSize: 11, color: Colors.green[600]),
          ),
        ],
      ),
    );
  }
}
