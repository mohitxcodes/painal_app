import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/VanshavaliScreen.dart';
import 'package:painal/screens/vanshavali/more-family/AddFamilyDrawer.dart';
import 'package:painal/screens/vanshavali/more-family/FamilyTreeScreen.dart';
import 'package:painal/screens/vanshavali/widgets/search_dialog.dart';
import 'package:provider/provider.dart';
import 'package:painal/apis/AuthProviderUser.dart';

// Main family data
Map<String, dynamic> mainFamily = {
  'id': 'main_family',
  'name': 'Main Family',
  'relation': 'Primary Family Tree',
  'collection': 'familyMembers', // Default collection for main family
  'icon': Icons.family_restroom_rounded,
  'isMain': true,
  'members': 0, // This will be updated after fetching
  'head': 'Head of Family',
  'profilePhoto': '', // Can be updated if you have a main family photo
};

// List to store fetched families
List<Map<String, dynamic>> familyMembers = [];

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
  bool _isLoading = true;
  String _errorMessage = '';

  // Search related
  final TextEditingController _searchController = TextEditingController();
  final List<FamilyMember> _familyData = []; // Will be populated if needed

  // Add family drawer
  void _openAddFamilyDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => AddFamilyDrawer(
            onSaved: () {
              Navigator.of(context).pop();
              _fetchFamilies(); // Refetch families after adding a new one
            },
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

    // Fetch families when the widget initializes
    _fetchFamilies();
  }

  Future<void> _fetchFamilies() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Fetch all families from the 'families' root collection
      final familiesSnapshot =
          await FirebaseFirestore.instance.collection('families').get();

      final List<Map<String, dynamic>> fetchedFamilies = [];

      for (final doc in familiesSnapshot.docs) {
        final data = doc.data();
        final collectionName = data['collectionName'] as String?;
        if (collectionName == null) continue;

        // Fetch the head member from the family collection
        final membersSnapshot =
            await FirebaseFirestore.instance
                .collection(collectionName)
                .limit(1)
                .get();

        final head =
            membersSnapshot.docs.isNotEmpty
                ? membersSnapshot.docs.first.data()
                : {};

        // Count total members
        final membersCountSnapshot =
            await FirebaseFirestore.instance.collection(collectionName).get();

        fetchedFamilies.add({
          'id': doc.id,
          'collection': collectionName,
          'name': data['name'] ?? collectionName,
          'head': head['name'] ?? data['headName'] ?? 'Head',
          'members': membersCountSnapshot.docs.length,
          'profilePhoto': head['profilePhoto'] ?? data['profilePhoto'] ?? '',
          'relation': data['relation'] ?? 'Family Branch',
          'isMain': false,
        });
      }

      // Fetch main family member count
      final mainFamilySnapshot =
          await FirebaseFirestore.instance
              .collection(mainFamily['collection'] ?? 'family')
              .get();
      final mainFamilyCount = mainFamilySnapshot.docs.length;

      if (mounted) {
        setState(() {
          // Find or initialize Main Family
          final mainFamilyIndex = familyMembers.indexWhere(
            (f) => f['isMain'] == true,
          );

          Map<String, dynamic> currentMainFamily;
          if (mainFamilyIndex != -1) {
            currentMainFamily = familyMembers[mainFamilyIndex];
          } else {
            // Use a copy of the global mainFamily to avoid issues
            currentMainFamily = Map<String, dynamic>.from(mainFamily);
          }

          // Update member count with actual count from DB
          currentMainFamily['members'] = mainFamilyCount;

          // Rebuild list: [Main Family, ... Fetched Families]
          familyMembers = [
            currentMainFamily,
            ...fetchedFamilies.where((f) => f['isMain'] != true),
          ];

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load families. Please try again.';
          _isLoading = false;
        });
      }
    }
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
    final authProvider = Provider.of<AuthProviderUser>(context);
    final totalMembers = familyMembers.fold<int>(
      0,
      (sum, family) =>
          sum + (family['members'] is int ? family['members'] as int : 0),
    );

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
          toolbarHeight: 110, // Increased height for custom header
          title: _VanshavaliListHeader(
            onSearchPressed: _showSearchDialog,
            totalMembers: totalMembers,
            familyCount: familyMembers.length,
          ),
        ),
        floatingActionButton:
            authProvider.isAdmin
                ? FloatingActionButton.extended(
                  onPressed: _openAddFamilyDrawer,
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Family'),
                  elevation: 2,
                )
                : null,
        body:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : _errorMessage.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchFamilies,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _fetchFamilies,
                  color: Colors.white,
                  backgroundColor: Colors.green[700],
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: familyMembers.length,
                    itemBuilder: (context, index) {
                      final family = familyMembers[index];
                      final isMainFamily = family['isMain'] == true;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        color: Colors.white.withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                        child: ListTile(
                          onTap:
                              isMainFamily
                                  ? () => _navigateWithAnimation(
                                    const VanshavaliScreen(),
                                  )
                                  : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => FamilyTreeScreen(
                                              onSearchPressed: () {},
                                              collectionName:
                                                  family['collection'],
                                              heading: family['name'],
                                              hindiHeading:
                                                  '(वंशावली - परिवार वृक्ष)',
                                              totalMembers: family['members'],
                                            ),
                                      ),
                                    );
                                  },
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  isMainFamily
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isMainFamily
                                  ? Icons.family_restroom_rounded
                                  : Icons.people_alt_rounded,
                              color:
                                  isMainFamily
                                      ? Colors.green[300]
                                      : Colors.blue[300],
                              size: 28,
                            ),
                          ),
                          title: Text(
                            family['name'] ?? 'Unnamed Family',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            isMainFamily
                                ? '${family['head']} • ${family['members']} members'
                                : '${family['head'] ?? 'Family'} • ${family['members']} members',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }

  void _navigateWithAnimation(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
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
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
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

class _VanshavaliListHeader extends StatelessWidget {
  final VoidCallback onSearchPressed;
  final int totalMembers;
  final int familyCount;

  const _VanshavaliListHeader({
    required this.onSearchPressed,
    required this.totalMembers,
    required this.familyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vanshavali',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Text(
                    '(वंशावली - परिवार वृक्ष)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Add some spacing before the button
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                color: Colors.white.withOpacity(0.18),
              ),
              child: IconButton(
                onPressed: onSearchPressed,
                tooltip: 'Search Family Member',
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            '$familyCount families • $totalMembers total members',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
