import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';

class AppFeaturesCarousel extends StatefulWidget {
  const AppFeaturesCarousel({super.key});

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
      'color': Colors.green[700],
      'bgIcon': Icons.family_restroom_rounded,
    },
    {
      'icon': Icons.menu_book,
      'title': 'Painal Book',
      'subtitle': 'Digital Village Book',
      'desc':
          'Read the digital book of Painal village, featuring its history & culture',
      'color': Colors.orange[700],
      'bgIcon': Icons.import_contacts_rounded,
    },
    {
      'icon': Icons.photo_library,
      'title': 'Gallery',
      'subtitle': 'Village Memories',
      'desc':
          'Browse a curated gallery of photos and memories from the village.',
      'color': Colors.blue[700],
      'bgIcon': Icons.collections_rounded,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap:
                          () => _onFeatureTap(
                            context,
                            feature['route'] as String,
                          ),
                      splashColor: Colors.white.withValues(alpha: 0.1),
                      highlightColor: Colors.white.withValues(alpha: 0.05),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: width > 600 ? 420 : width - 32,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.15),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            // Background Icon Effect
                            Positioned(
                              right: -10,
                              top: -10,
                              child: Icon(
                                feature['bgIcon'] as IconData,
                                color: Colors.white.withValues(alpha: 0.10),
                                size: 100,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    feature['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(
                                        alpha: 0.72,
                                      ),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    feature['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
    );
  }
}
