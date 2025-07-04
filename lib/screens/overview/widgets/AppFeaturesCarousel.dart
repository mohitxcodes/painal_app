import 'package:flutter/material.dart';
import 'dart:async';

class AppFeaturesCarousel extends StatefulWidget {
  const AppFeaturesCarousel({Key? key}) : super(key: key);

  @override
  State<AppFeaturesCarousel> createState() => _AppFeaturesCarouselState();
}

class _AppFeaturesCarouselState extends State<AppFeaturesCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoTimer;

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.account_tree,
      'title': 'Vanshavali',
      'subtitle': 'Family Tree',
      'desc':
          'Explore your family tree, lineage, and discover relationships across generations.',
      'button': 'View Tree',
      'color': Colors.green[700],
    },
    {
      'icon': Icons.menu_book,
      'title': 'Painal Book',
      'subtitle': 'Digital Village Book',
      'desc':
          'Read the digital book of Painal village, featuring its history & culture',
      'button': 'Read Book',
      'color': Colors.orange[700],
    },
    {
      'icon': Icons.photo_library,
      'title': 'Gallery',
      'subtitle': 'Village Memories',
      'desc':
          'Browse a curated gallery of photos and memories from the village.',
      'button': 'Open Gallery',
      'color': Colors.blue[700],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      int nextPage = _currentPage + 1;
      if (nextPage >= _features.length) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onFeatureTap(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.green[50],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'App Features',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.black,
                  letterSpacing: 0.5,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _features.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _startAutoAdvance();
              },
              itemBuilder: (context, i) {
                final feature = _features[i];
                return Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap:
                        () =>
                            _onFeatureTap(context, feature['route'] as String),
                    splashColor: (feature['color'] as Color).withOpacity(0.08),
                    highlightColor: (feature['color'] as Color).withOpacity(
                      0.04,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: width > 600 ? 420 : width - 32,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: (feature['color'] as Color).withOpacity(
                              0.08,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: (feature['color'] as Color).withOpacity(0.13),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (feature['color'] as Color).withOpacity(
                                0.13,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              feature['icon'] as IconData,
                              color: (feature['color'] as Color).withOpacity(
                                0.7,
                              ),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      feature['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      feature['subtitle'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: feature['color'] as Color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  feature['desc'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_features.length, (index) {
              final isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: isActive ? 24 : 10,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? (_features[index]['color'] as Color)
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
