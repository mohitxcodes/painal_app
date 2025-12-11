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
        name: 'श्री रामेश कुमार',
        englishName: 'Shri Ramesh Kumar',
        position: 'मुखिया',
        imageUrl: '',
        tenure: '2020 - वर्तमान',
      ),
      PoliticalLeader(
        name: 'श्रीमती सुनीता देवी',
        englishName: 'Smt. Sunita Devi',
        position: 'सरपंच',
        imageUrl: '',
        tenure: '2020 - वर्तमान',
      ),
    ];

    // Historical leaders data
    final List<MapEntry<String, List<PoliticalLeader>>> historicalLeaders = [
      MapEntry('2020 - 2025', [
        PoliticalLeader(
          name: 'श्री रामेश कुमार',
          englishName: 'Shri Ramesh Kumar',
          position: 'मुखिया',
          imageUrl: '',
          tenure: '2020 - 2025',
        ),
        PoliticalLeader(
          name: 'श्रीमती सुनीता देवी',
          englishName: 'Smt. Sunita Devi',
          position: 'सरपंच',
          imageUrl: '',
          tenure: '2020 - 2025',
        ),
      ]),
      MapEntry('2015 - 2020', [
        PoliticalLeader(
          name: 'श्री राजेश शर्मा',
          englishName: 'Shri Rajesh Sharma',
          position: 'मुखिया',
          imageUrl: '',
          tenure: '2015 - 2020',
        ),
        PoliticalLeader(
          name: 'श्रीमती मीना देवी',
          englishName: 'Smt. Meena Devi',
          position: 'सरपंच',
          imageUrl: '',
          tenure: '2015 - 2020',
        ),
      ]),
      MapEntry('2010 - 2015', [
        PoliticalLeader(
          name: 'श्री अमित सिंह',
          englishName: 'Shri Amit Singh',
          position: 'मुखिया',
          imageUrl: '',
          tenure: '2010 - 2015',
        ),
        PoliticalLeader(
          name: 'श्रीमती रेखा शर्मा',
          englishName: 'Smt. Rekha Sharma',
          position: 'सरपंच',
          imageUrl: '',
          tenure: '2010 - 2015',
        ),
      ]),
      MapEntry('2005 - 2010', [
        PoliticalLeader(
          name: 'श्री विजय कुमार',
          englishName: 'Shri Vijay Kumar',
          position: 'मुखिया',
          imageUrl: '',
          tenure: '2005 - 2010',
        ),
        PoliticalLeader(
          name: 'श्रीमती आशा देवी',
          englishName: 'Smt. Asha Devi',
          position: 'सरपंच',
          imageUrl: '',
          tenure: '2005 - 2010',
        ),
      ]),
      MapEntry('2000 - 2005', [
        PoliticalLeader(
          name: 'श्री राकेश वर्मा',
          englishName: 'Shri Rakesh Verma',
          position: 'मुखिया',
          imageUrl: '',
          tenure: '2000 - 2005',
        ),
        PoliticalLeader(
          name: 'श्रीमती सुनीता देवी',
          englishName: 'Smt. Sunita Devi',
          position: 'सरपंच',
          imageUrl: '',
          tenure: '2000 - 2005',
        ),
      ]),
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
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Leaders Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                'Current Leadership (Present)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...currentLeaders.map((leader) => LeaderCard(leader: leader)),

            // Historical Leaders Section
            const Padding(
              padding: EdgeInsets.only(top: 32.0, bottom: 16.0, left: 8.0),
              child: Text(
                'Leadership Timeline (Historical)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...historicalLeaders.asMap().entries.map((entry) {
              final index = entry.key;
              final yearEntry = entry.value;
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (index * 100)),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    // Timeline connector
                    if (index > 0)
                      Container(
                        width: 2,
                        height: 24,
                        margin: const EdgeInsets.only(left: 23),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    // Timeline item
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline dot and year
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  yearEntry.key,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...yearEntry.value.map(
                                (leader) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: LeaderCard(leader: leader),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
