import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Village Landscape',
      'titleHindi': 'गाँव का दृश्य',
      'image': 'assets/images/village_landscape.jpg',
    },
    {
      'title': 'Local Market',
      'titleHindi': 'स्थानीय बाजार',
      'image': 'assets/images/local_market.jpg',
    },
    {
      'title': 'Community Life',
      'titleHindi': 'सामुदायिक जीवन',
      'image': 'assets/images/community.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentPage < _carouselItems.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _carouselItems.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green[700]!,
                      Colors.green[500]!,
                      Colors.green[300]!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Placeholder for image (you can replace with actual images)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green[100],
                      ),
                      child: Center(
                        child: Icon(
                          _getIconForIndex(index),
                          size: 80,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    // Gradient overlay for text readability
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    // Text overlay at bottom left with bilingual content
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // English Title
                          Text(
                            _carouselItems[index]['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Hindi Title
                          Text(
                            _carouselItems[index]['titleHindi']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Page indicator
          Positioned(
            bottom: 10,
            right: 20,
            child: Row(
              children: List.generate(
                _carouselItems.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.landscape;
      case 1:
        return Icons.store;
      case 2:
        return Icons.people;
      default:
        return Icons.landscape;
    }
  }
}
