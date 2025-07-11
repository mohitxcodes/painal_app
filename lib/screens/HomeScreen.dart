import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:painal/apis/AuthProviderUser.dart';
import 'package:painal/screens/vanshavali/VanshavaliScreen.dart';
import 'package:provider/provider.dart';
import 'overview/OverviewScreen.dart';
import 'book/BookScreen.dart';
import 'gallery/GalleryScreen.dart';
import 'package:painal/screens/login/LoginScreen.dart';
import 'package:painal/screens/login/widgets/AccountDrawer.dart';

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderUser>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Painal Village',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              'पैनाल गाँव',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 6.0, bottom: 6.0),
            child:
                authProvider.isAdmin
                    ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 1.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.1,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.18),
                          builder:
                              (context) => AccountDrawer(
                                email: authProvider.user?.email ?? '',
                                onLogout: () async {
                                  await FirebaseAuth.instance.signOut();
                                  if (mounted) Navigator.of(context).pop();
                                },
                              ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.account_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text('My Account'),
                        ],
                      ),
                    )
                    : OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 1.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.1,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.login, size: 14, color: Colors.white),
                          SizedBox(width: 2),
                          Text('Login'),
                        ],
                      ),
                    ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Home', icon: Icon(Icons.home)),
            Tab(text: 'Vanshavali', icon: Icon(Icons.people)),
            Tab(text: 'Book', icon: Icon(Icons.book)),
            Tab(text: 'Gallery', icon: Icon(Icons.photo_library)),
          ],
        ),
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
    );
  }
}
