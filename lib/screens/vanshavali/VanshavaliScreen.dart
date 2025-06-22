import 'package:flutter/material.dart';

class VanshavaliScreen extends StatelessWidget {
  const VanshavaliScreen({super.key});

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
                    'Vanshali - Community & Culture',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Painal village is a vibrant community with rich cultural heritage and strong social bonds.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _buildCommunitySection('Languages Spoken', [
                    'Hindi (Primary)',
                    'Magahi',
                    'Maithili',
                    'Bhojpuri',
                    'English',
                    'Angika',
                  ]),
                  const SizedBox(height: 20),
                  _buildCommunitySection('Political Representation', [
                    'Assembly Constituency: Maner',
                    'MLA: Bhai Virendra',
                    'Lok Sabha: Pataliputra',
                    'MP: RAM KRIPAL YADAV',
                  ]),
                  const SizedBox(height: 20),
                  _buildCommunitySection('Community Features', [
                    'Population: 9,618 people',
                    '1,601 households',
                    'Strong agricultural community',
                    'Traditional village governance',
                    'Active local markets and commerce',
                  ]),
                  const SizedBox(height: 20),
                  _buildCommunitySection('Cultural Heritage', [
                    'Traditional festivals and celebrations',
                    'Local customs and traditions',
                    'Community gatherings and events',
                    'Agricultural festivals',
                    'Religious and spiritual practices',
                  ]),
                  const SizedBox(height: 20),
                  _buildCommunitySection('Social Structure', [
                    'Close-knit community bonds',
                    'Elder respect and wisdom sharing',
                    'Youth engagement in village activities',
                    'Women empowerment initiatives',
                    'Educational awareness programs',
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySection(String title, List<String> items) {
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
                const Icon(
                  Icons.fiber_manual_record,
                  size: 8,
                  color: Colors.green,
                ),
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
