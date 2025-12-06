import 'package:flutter/material.dart';
import 'package:painal/screens/vanshavali/VanshavaliScreen.dart';
import 'overview/OverviewScreen.dart';
import 'book/BookScreen.dart';
import 'gallery/GalleryScreen.dart';
import 'package:painal/screens/settings/SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _IconTextTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconTextTab({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
            VanshavaliScreen(),
            BookScreen(),
            GalleryScreen(),
          ],
        ),
        bottomNavigationBar: Material(
          elevation: 0,
          color: Colors.transparent,
          child: SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.15)),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B3B2D), Color(0xFF134B30)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 13),
                tabs: const [
                  _IconTextTab(icon: Icons.home_filled, label: 'Home'),
                  _IconTextTab(
                    icon: Icons.family_restroom,
                    label: 'Vanshavali',
                  ),
                  _IconTextTab(icon: Icons.menu_book_rounded, label: 'Explore'),
                ],
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
      color: Colors.white.withOpacity(0.18),
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
