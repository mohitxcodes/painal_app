import 'package:flutter/material.dart';
import 'package:painal/models/political_leader.dart';
import 'package:painal/widgets/leader_card.dart';

class PoliticalLeadersScreen extends StatelessWidget {
  const PoliticalLeadersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data - replace with your actual data
    final List<PoliticalLeader> currentLeaders = [
      PoliticalLeader(
        name: 'Shri Ramesh Kumar',
        position: 'Mukhiya',
        imageUrl: '',
        tenure: '2020 - Present',
      ),
      PoliticalLeader(
        name: 'Smt. Sunita Devi',
        position: 'Sarpanch',
        imageUrl: '',
        tenure: '2020 - Present',
      ),
    ];

    // Historical leaders data
    final List<MapEntry<String, List<PoliticalLeader>>> historicalLeaders = [
      MapEntry('2015 - 2020', [
        PoliticalLeader(
          name: 'Shri Rajesh Sharma',
          position: 'Mukhiya',
          imageUrl: '',
          tenure: '2015 - 2020',
        ),
        PoliticalLeader(
          name: 'Smt. Meena Devi',
          position: 'Sarpanch',
          imageUrl: '',
          tenure: '2015 - 2020',
        ),
      ]),
      // Add more years as needed
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B3B2D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Political Leaders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Leaders Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                'Current Leadership',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...currentLeaders.map((leader) => LeaderCard(leader: leader)),

            // Historical Leaders Section
            const Padding(
              padding: EdgeInsets.only(
                top: 24.0,
                bottom: 16.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Text(
                'Historical Leadership',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...historicalLeaders.expand(
              (entry) => [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...entry.value.map((leader) => LeaderCard(leader: leader)),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
