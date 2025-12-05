import 'package:flutter/material.dart';
import 'package:painal/screens/overview/widgets/AppFeaturesCarousel.dart';
import 'package:painal/utils/village_stat_card.dart';

class AboutVillageWidget extends StatefulWidget {
  const AboutVillageWidget({super.key});

  @override
  State<AboutVillageWidget> createState() => _AboutVillageWidgetState();
}

class _AboutVillageWidgetState extends State<AboutVillageWidget> {
  final List<String> images = [
    'assets/images/banner_01.png',
    'assets/images/banner_02.png',
    'assets/images/banner_03.png',
  ];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _autoPlaying = false;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (_autoPlaying) return;
    _autoPlaying = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      int nextPage = _currentPage + 1;
      if (nextPage >= images.length) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      return mounted;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'नमस्ते!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        images[index],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                // Page indicator
                Positioned(
                  bottom: 8,
                  right: 20,
                  child: Row(
                    children: List.generate(
                      images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? Colors.green
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 6),
                      Text(
                        'Welcome to Painal Village',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Experience the soul of rural Bihar—its stories, people, and traditions—curated beautifully for you.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.map_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Discover Painal Stories',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          // Carousel of images at the top
          AppFeaturesCarousel(),
          const SizedBox(height: 12),
          // Description with colored left border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: const Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'About Painal Village',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'पैनाल गाँव के बारे में',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Text(
                  'Village Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Painal is a vibrant village located in Bihta Block of Patna District, Bihar. With a population of 9,618 people, it represents the rich cultural heritage and agricultural traditions of rural India.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.87),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'The village is known for its strong community bonds, traditional festivals, and active participation in local governance.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.87),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Read More',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Key features in a grid with animation
          Row(
            children: [
              const Expanded(
                child: VillageStatCard(
                  icon: Icons.people,
                  value: '9,618',
                  primaryLabel: 'Population',
                  secondaryLabel: 'जनसंख्या',
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: VillageStatCard(
                  icon: Icons.home,
                  value: '1,601',
                  primaryLabel: 'Houses',
                  secondaryLabel: 'घर',
                  duration: Duration(milliseconds: 700),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: VillageStatCard(
                  icon: Icons.school,
                  value: '60.3%',
                  primaryLabel: 'Literacy',
                  secondaryLabel: 'साक्षरता',
                  duration: Duration(milliseconds: 800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
