import 'package:flutter/material.dart';

class InfrastructureWidget extends StatelessWidget {
  const InfrastructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: Colors.green[700], size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'Infrastructure',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildInfoRow(
                'Schools',
                'St Karens School, NISHANT MEMORIAL SCHOOL, East & West High School',
              ),
              _buildInfoRow(
                'Colleges',
                'Ram Bahadur Singh Inter College, Bidya Evening College',
              ),
              _buildInfoRow(
                'Petrol Pumps',
                'Indian Oil Petroleum, LAXMI NARAYAN KSK',
              ),
              _buildInfoRow(
                'Police Stations',
                'Neora Police Station (5.5 KM), Parsa Police Station (7.3 KM)',
              ),
              _buildInfoRow(
                'Government Offices',
                'Krishi Bhawan (4.5 KM), NEORA PACS (4.8 KM)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
