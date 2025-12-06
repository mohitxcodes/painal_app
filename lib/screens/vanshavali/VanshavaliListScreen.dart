import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/VanshavaliScreen.dart';
import 'package:painal/screens/vanshavali/more-family/MoreFamilyScreen.dart';
import 'package:painal/screens/vanshavali/widgets/search_dialog.dart';
import 'package:painal/screens/vanshavali/widgets/vanshavali_header.dart';

class VanshavaliListScreen extends StatefulWidget {
  const VanshavaliListScreen({super.key});

  @override
  State<VanshavaliListScreen> createState() => _VanshavaliListScreenState();
}

class _VanshavaliListScreenState extends State<VanshavaliListScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Search related
  final TextEditingController _searchController = TextEditingController();
  final List<FamilyMember> _familyData = []; // Will be populated if needed

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  // Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchDialog(
          familyData: _familyData,
          onMemberSelected: (member) {
            Navigator.pop(context);
            // You can add navigation to member details here if needed
            _showComingSoon('Member Details');
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B3B2D), Color(0xFF1F6B3A)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: VanshavaliHeader(
            heading: 'Vanshavali',
            hindiHeading: '(वंशावली - परिवार वृक्ष)',
            totalMembers: 0, // Not used in this screen
            onSearchPressed: _showSearchDialog,
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  _buildCreativeFeatureCard(
                    icon: Icons.family_restroom_rounded,
                    title: 'Main Family',
                    subtitle: 'Primary family lineage',
                    description: 'Explore the main village family tree',
                    color: Colors.white,
                    onTap:
                        () => _navigateWithAnimation(const VanshavaliScreen()),
                    delay: 0,
                    bgIcon: Icons.home_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildCreativeFeatureCard(
                    icon: Icons.diversity_3_rounded,
                    title: 'More Vanshavali',
                    subtitle: 'Extended family branches',
                    description: 'Discover additional family trees',
                    color: Colors.white,
                    onTap:
                        () => _navigateWithAnimation(const MoreFamilyScreen()),
                    delay: 100,
                    bgIcon: Icons.groups_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildCreativeFeatureCard(
                    icon: Icons.history_edu_rounded,
                    title: 'Family History',
                    subtitle: 'Ancestral records',
                    description: 'Browse historical family documents',
                    color: Colors.white,
                    onTap: () => _showComingSoon('Family History Archives'),
                    delay: 200,
                    isComingSoon: true,
                    bgIcon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildCreativeFeatureCard(
                    icon: Icons.photo_album_rounded,
                    title: 'Family Gallery',
                    subtitle: 'Visual memories',
                    description: 'View family photos and memories',
                    color: Colors.white,
                    onTap: () => _showComingSoon('Family Photo Gallery'),
                    delay: 300,
                    isComingSoon: true,
                    bgIcon: Icons.collections_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildCreativeFeatureCard(
                    icon: Icons.location_on_rounded,
                    title: 'Family Locations',
                    subtitle: 'Ancestral places',
                    description: 'Map important family locations',
                    color: Colors.white,
                    onTap: () => _showComingSoon('Family Location Map'),
                    delay: 400,
                    isComingSoon: true,
                    bgIcon: Icons.place_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreativeFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required int delay,
    bool isComingSoon = false,
    required IconData bgIcon,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + delay),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (value * 0.1),
          child: Opacity(
            opacity: value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                splashColor: color.withOpacity(0.2),
                highlightColor: color.withOpacity(0.1),
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Icon
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          bgIcon,
                          color: Colors.white.withOpacity(0.05),
                          size: 80,
                        ),
                      ),

                      // Main Content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            // Icon Container
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(icon, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 20),

                            // Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      if (isComingSoon) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                color.withOpacity(0.3),
                                                color.withOpacity(0.1),
                                              ],
                                            ),
                                            border: Border.all(
                                              color: color.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            'Coming',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Arrow Icon
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white.withOpacity(0.7),
                              size: 18,
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
    );
  }

  void _navigateWithAnimation(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(
                Icons.upcoming_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text('$feature - Coming Soon!'),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
