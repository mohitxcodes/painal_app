import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Book - Village Records & Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBookSection('Census Records', [
                    'Total Population: 9,618',
                    'Male Population: 5,098 (53.0%)',
                    'Female Population: 4,520 (47.0%)',
                    'Total Houses: 1,601',
                    'Literacy Rate: 60.3%',
                    'Female Literacy: 24.0%',
                  ]),
                  const SizedBox(height: 20),
                  _buildBookSection('Geographic Information', [
                    'Location: 21 KM west of Patna',
                    'Block: Bihta',
                    'District: Patna',
                    'State: Bihar',
                    'Elevation: 62 meters above sea level',
                    'Pin Code: 800111',
                  ]),
                  const SizedBox(height: 20),
                  _buildBookSection('Infrastructure Records', [
                    'Schools: Multiple government and private schools',
                    'Colleges: Higher education institutions nearby',
                    'Transport: Connected by NH139 and NH922',
                    'Railway: Multiple stations within 10 KM',
                    'Healthcare: Medical facilities available',
                    'Markets: Local markets and commercial areas',
                  ]),
                  const SizedBox(height: 20),
                  _buildBookSection('Historical Records', [
                    'Village establishment and history',
                    'Traditional governance systems',
                    'Agricultural development timeline',
                    'Educational progress records',
                    'Infrastructure development history',
                  ]),
                  const SizedBox(height: 20),
                  _buildBookSection('Economic Records', [
                    'Primary occupation: Agriculture',
                    'Local market activities',
                    'Small-scale industries',
                    'Employment statistics',
                    'Economic development indicators',
                  ]),
                  const SizedBox(height: 20),
                  _buildBookSection('Administrative Records', [
                    'Village Panchayat details',
                    'Government schemes implementation',
                    'Public distribution system',
                    'Health and sanitation records',
                    'Development project documentation',
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              children: [
                const Icon(Icons.book, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
