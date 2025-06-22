import 'package:flutter/material.dart';

class LocationInfoWidget extends StatelessWidget {
  const LocationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and bilingual title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Location Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            'स्थान की जानकारी',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Location details in a grid layout
                Row(
                  children: [
                    Expanded(
                      child: _buildLocationCard(
                        'Block',
                        'ब्लॉक',
                        'Bihta',
                        Icons.location_city,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildLocationCard(
                        'District',
                        'जिला',
                        'Patna',
                        Icons.map,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildLocationCard(
                        'State',
                        'राज्य',
                        'Bihar',
                        Icons.flag,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildLocationCard(
                        'Division',
                        'मंडल',
                        'Patna',
                        Icons.account_balance,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildLocationCard(
                        'Pin Code',
                        'पिन कोड',
                        '800111',
                        Icons.mail,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildLocationCard(
                        'Post Office',
                        'डाकघर',
                        'Painal',
                        Icons.local_post_office,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Additional information section
                const Text(
                  'Additional Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Distance from Patna', 'पटना से दूरी', '21 KM'),
                _buildInfoRow('Distance from Bihta', 'बिहटा से दूरी', '9 KM'),
                _buildInfoRow(
                  'Elevation',
                  'ऊंचाई',
                  '62 meters above sea level',
                ),
                _buildInfoRow('Languages', 'भाषाएं', 'Magahi, Hindi'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    String labelEnglish,
    String labelHindi,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green[700], size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            labelEnglish,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            labelHindi,
            style: TextStyle(fontSize: 9, color: Colors.green[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String labelEnglish, String labelHindi, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelEnglish,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  labelHindi,
                  style: TextStyle(color: Colors.green[600], fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
