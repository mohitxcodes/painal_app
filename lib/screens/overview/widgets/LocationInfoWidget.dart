import 'package:flutter/material.dart';

class LocationInfoWidget extends StatelessWidget {
  const LocationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'स्थान की जानकारी',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLocationCard(
                    'District',
                    'जिला',
                    'Patna',
                    Icons.map,
                  ),
                ),
                const SizedBox(width: 12),
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
            const SizedBox(height: 12),
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
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLocationCard(
                    'Pin Code',
                    'पिन कोड',
                    '800111',
                    Icons.mail,
                  ),
                ),
                const SizedBox(width: 12),
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
            const SizedBox(height: 18),
            // Stepper/timeline for Additional Details
            const Text(
              'Additional Details',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildAdditionalDetailCard(
                    'Distance from Patna',
                    'पटना से दूरी',
                    '21 KM',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdditionalDetailCard(
                    'Languages',
                    'भाषाएं',
                    'Magahi, Hindi',
                  ),
                ),
              ],
            ),
          ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.13)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green[700], size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            labelEnglish,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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

  Widget _buildAdditionalDetailCard(
    String labelEnglish,
    String labelHindi,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            labelEnglish,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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
}
