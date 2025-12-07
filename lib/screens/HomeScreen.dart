import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:painal/screens/vanshavali/VanshavaliListScreen.dart';
import 'overview/OverviewScreen.dart';

import 'package:painal/screens/settings/SettingsScreen.dart';
import 'package:painal/screens/explore/ExploreScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF0B3B2D)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: const SizedBox.shrink(),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/painal_round_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Painal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: '  |  ',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: 'पैनाल',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: _buildActionIcon(
                icon: Icons.settings,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            OverviewScreen(),
            VanshavaliListScreen(),
            ExploreScreen(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B3B2D).withValues(alpha: 0.8),

                  //
                  // gradient: LinearGradient(
                  //   colors: [
                  //     const Color(0xFF1F6B3A).withValues(alpha: 0.9),
                  //   ],
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  // ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.home_rounded),
                      text: 'Home',
                      iconMargin: EdgeInsets.only(bottom: 2),
                    ),
                    Tab(
                      icon: Icon(Icons.family_restroom_rounded),
                      text: 'Vanshavali',
                      iconMargin: EdgeInsets.only(bottom: 2),
                    ),
                    Tab(
                      icon: Icon(Icons.explore_rounded),
                      text: 'Explore',
                      iconMargin: EdgeInsets.only(bottom: 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final borderRadius = BorderRadius.circular(12);
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
