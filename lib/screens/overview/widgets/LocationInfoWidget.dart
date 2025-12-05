import 'package:flutter/material.dart';

class LocationInfoWidget extends StatelessWidget {
  const LocationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.16),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white24,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      Text(
                        'स्थान की जानकारी',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.75),
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
                color: Colors.white,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.07),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            labelEnglish,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            labelHindi,
            style: TextStyle(fontSize: 10, color: Colors.white70),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.16),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            labelEnglish,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            labelHindi,
            style: TextStyle(fontSize: 9, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
