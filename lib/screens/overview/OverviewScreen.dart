import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVillageHeader(),
          const SizedBox(height: 20),
          _buildLocationInfo(),
          const SizedBox(height: 20),
          _buildDemographics(),
          const SizedBox(height: 20),
          _buildWeatherInfo(),
          const SizedBox(height: 20),
          _buildNearbyPlaces(),
          const SizedBox(height: 20),
          _buildInfrastructure(),
        ],
      ),
    );
  }

  Widget _buildVillageHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.location_city, size: 50, color: Colors.white),
          const SizedBox(height: 10),
          const Text(
            'Painal Village',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'पैनल',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          const Text(
            'A vibrant village in Bihta Block, Patna District, Bihar',
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
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
    );
  }

  Widget _buildDemographics() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demographics (2011 Census)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Total Population', '9,618'),
            _buildInfoRow('Total Houses', '1,601'),
            _buildInfoRow('Female Population', '47.0% (4,520)'),
            _buildInfoRow('Literacy Rate', '60.3% (5,802)'),
            _buildInfoRow('Female Literacy', '24.0%'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Weather',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.thermostat, color: Colors.orange, size: 30),
                const SizedBox(width: 10),
                const Text(
                  '32.0°C',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Humidity: 70%'),
                    Text('Wind: 2.06 m/s S'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Weather Station: Maner (32 mins ago)'),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyPlaces() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearby Places',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
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
    );
  }

  Widget _buildInfrastructure() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Infrastructure',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
