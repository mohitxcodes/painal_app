import 'package:flutter/material.dart';

class NearbyPlacesWidget extends StatelessWidget {
  const NearbyPlacesWidget({super.key});

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
                  Icon(Icons.place, color: Colors.green[700], size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'Nearby Places',
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
                'Nearest Villages',
                'Makhdumpur (2 KM), Bela (2 KM), Sadisopur (4 KM)',
              ),
              _buildInfoRow(
                'Nearby Cities',
                'Maner (12 KM), Patna (22 KM), Dighwara (22 KM)',
              ),
              _buildInfoRow(
                'Airports',
                'Patna Airport (16 KM), Gaya Airport (102 KM)',
              ),
              _buildInfoRow(
                'Railway Stations',
                'Sadisopur (3.9 KM), Neora (4.4 KM), Bihta (8 KM)',
              ),
              _buildInfoRow('National Highways', 'NH139, NH922'),
              _buildInfoRow('Rivers', 'Son, Ganges'),
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
