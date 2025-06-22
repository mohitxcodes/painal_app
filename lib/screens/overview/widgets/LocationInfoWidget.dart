import 'package:flutter/material.dart';

class LocationInfoWidget extends StatelessWidget {
  const LocationInfoWidget({super.key});

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
                  Icon(Icons.location_on, color: Colors.green[700], size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'Location Information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildInfoRow('Block', 'Bihta'),
              _buildInfoRow('District', 'Patna'),
              _buildInfoRow('State', 'Bihar'),
              _buildInfoRow('Division', 'Patna'),
              _buildInfoRow('Pin Code', '800111'),
              _buildInfoRow('Post Office', 'Sadisopur'),
              _buildInfoRow('Distance from Patna', '21 KM'),
              _buildInfoRow('Distance from Bihta', '9 KM'),
              _buildInfoRow('Elevation', '62 meters above sea level'),
              _buildInfoRow(
                'Languages',
                'Hindi, Magahi, Maithili, Bhojpuri, English, Angika',
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
