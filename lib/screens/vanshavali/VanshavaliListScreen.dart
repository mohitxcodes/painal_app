import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
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
              Navigator.of(context).pop();
              _loadFamilies(forceRefresh: true); // Refetch after adding new
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

    // Load families from cache first, then fetch background update if needed
    _loadFamilies();
  }

  Future<void> _loadFamilies({bool forceRefresh = false}) async {
    if (!mounted) return;

    // 1. Try to load from Cache first (unless forcing refresh)
    if (!forceRefresh) {
      try {
        var box = await Hive.openBox('vanshavali_list_cache');
        if (box.isNotEmpty) {
          final cachedData = box.get('families');
          if (cachedData != null) {
            final List<dynamic> decoded = cachedData;
            final List<Map<String, dynamic>> cachedList =
                decoded.map((e) => Map<String, dynamic>.from(e)).toList();

            setState(() {
              familyMembers = cachedList;
              _isLoading = false;
            });
            // Optional: Still fetch in background to keep data fresh
            _fetchFamiliesFromFirestore(updateCache: true);
            return;
          }
        }
      } catch (e) {
        print("Cache load error: $e");
        // Proceed to fetch from firestore if cache fails
      }
    }

    // 2. If no cache or force refresh, fetch from Firestore
    await _fetchFamiliesFromFirestore(updateCache: true);
  }

  Future<void> _fetchFamiliesFromFirestore({bool updateCache = true}) async {
    if (!mounted) return;

    // Only show loading if we don't have data yet
    if (familyMembers.isEmpty) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

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

      // Fetch main family member count and head
      final mainFamilySnapshot =
          await FirebaseFirestore.instance
              .collection(mainFamily['collection'] ?? 'familyMembers')
              .get();
      final mainFamilyCount = mainFamilySnapshot.docs.length;

      // Find main family head
      String mainFamilyHeadName = mainFamily['head'] ?? 'Head of Family';
      String mainFamilyDisplayName = mainFamily['name'] ?? 'Main Family';

      try {
        if (mainFamilySnapshot.docs.isNotEmpty) {
          final headDoc = mainFamilySnapshot.docs.firstWhere(
            (doc) => doc.data()['parentId'] == null,
            orElse: () => mainFamilySnapshot.docs.first,
          );
          final String? name = headDoc.data()['name'];
          if (name != null && name.isNotEmpty) {
            mainFamilyHeadName = name;
            // User requested showing head name. Appending 'Family' for consistency.
            mainFamilyDisplayName = '$name Family';
          }
        }
      } catch (e) {
        debugPrint('Error finding main family head: $e');
      }

      if (mounted) {
        setState(() {
          // Find or initialize Main Family
          final mainFamilyIndex = familyMembers.indexWhere(
            (f) => f['isMain'] == true,
          );

          Map<String, dynamic> currentMainFamily;
          if (familyMembers.isNotEmpty && mainFamilyIndex != -1) {
            currentMainFamily = familyMembers[mainFamilyIndex];
          } else {
            // Use a copy of the global mainFamily to avoid issues
            currentMainFamily = Map<String, dynamic>.from(mainFamily);
          }

          // Update member count and name with actual data from DB
          currentMainFamily['members'] = mainFamilyCount;

          // CRITICAL: Ensure we overwrite the name if we found a better one
          if (mainFamilyDisplayName != 'Main Family') {
            currentMainFamily['name'] = mainFamilyDisplayName;
          }
          currentMainFamily['head'] = mainFamilyHeadName;

          // Rebuild list: [Main Family, ... Fetched Families]
          // Filter out any existing main family entry from fetched list to avoid duplication
          final otherFamilies =
              fetchedFamilies.where((f) => f['isMain'] != true).toList();

          familyMembers = [currentMainFamily, ...otherFamilies];
          _isLoading = false;
        });

        // 3. Save to Cache
        if (updateCache) {
          try {
            var box = await Hive.openBox('vanshavali_list_cache');
            await box.put('families', familyMembers);
          } catch (e) {
            print("Cache save error: $e");
          }
        }
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
          // No local familyData provided for global search
          onSearch: _globalSearch,
          onMemberSelected: (member) {
            Navigator.pop(context);
            // Navigate based on collection
            final isMain =
                member.collectionName ==
                (mainFamily['collection'] ?? 'familyMembers');

            if (isMain) {
              _navigateWithAnimation(const VanshavaliScreen());
            } else {
              // Find family details for the screen title
              final family = familyMembers.firstWhere(
                (f) => f['collection'] == member.collectionName,
                orElse: () => {},
              );

              final heading = family['name'] ?? 'Family Tree';
              final totalMembers = family['members'] ?? 0;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => FamilyTreeScreen(
                        onSearchPressed:
                            () {}, // Search inside tree not needed immediately or can trigger local search
                        collectionName: member.collectionName!,
                        heading: heading,
                        hindiHeading: '(वंशावली - परिवार वृक्ष)',
                        totalMembers: totalMembers is int ? totalMembers : 0,
                      ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<List<FamilyMember>> _globalSearch(String query) async {
    if (query.length < 2) return [];

    final List<Future<List<FamilyMember>>> futures = [];

    // Search in all known collections
    for (var family in familyMembers) {
      final collectionName = family['collection'] as String?;
      if (collectionName != null) {
        futures.add(_searchInCollection(collectionName, query));
      }
    }

    final results = await Future.wait(futures);
    // Flatten results
    return results.expand((i) => i).toList();
  }

  Future<List<FamilyMember>> _searchInCollection(
    String collectionName,
    String query,
  ) async {
    try {
      // Create a query for name prefix match
      // Note: Firestore text search is limited. This is a basic prefix match.
      // For more advanced search, Algolia or similar is recommended.
      // We check both name and hindiName manual filtering or multiple queries if needed.
      // Here we fetch a subset or try to match exactly/prefix.
      // For simplicity and cost, we might do client side filtering if lists are small,
      // but user asked for "whole data". Assuming reasonable size, we query.

      // Queries
      final nameQuery =
          FirebaseFirestore.instance
              .collection(collectionName)
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThan: '$query\uf8ff')
              .limit(5)
              .get();

      // We can't do OR query easily across fields without Composite Indexes or multiple queries.
      // We will execute name query first.
      final snapshot = await nameQuery;

      return snapshot.docs.map((doc) {
        final member = FamilyMember.fromMap(doc.data());
        member.collectionName = collectionName;
        return member;
      }).toList();
    } catch (e) {
      print('Error searching $collectionName: $e');
      return [];
    }
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
          colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
          stops: [0.0, 1.0],
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
                        onPressed: () => _loadFamilies(forceRefresh: true),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () => _loadFamilies(forceRefresh: true),
                  color: Colors.white,
                  backgroundColor: Colors.green[700],
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 100,
                    ),
                    itemCount: familyMembers.length,
                    itemBuilder: (context, index) {
                      final family = familyMembers[index];
                      final isMainFamily = family['isMain'] == true;

                      // Formatting Helper
                      String formatFamilyName(String name) {
                        return name
                            .replaceAll('_', ' ')
                            .split(' ')
                            .map(
                              (word) =>
                                  word.isNotEmpty
                                      ? '${word[0].toUpperCase()}${word.substring(1)}'
                                      : '',
                            )
                            .join(' ');
                      }

                      final displayName = formatFamilyName(
                        family['name'] ?? 'Unnamed Family',
                      );

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMainFamily
                                  ? const Color(0xFFFBC02D).withOpacity(0.15)
                                  : Colors.white.withOpacity(0.08),
                          gradient: LinearGradient(
                            colors:
                                isMainFamily
                                    ? [
                                      const Color(0xFFFBC02D).withOpacity(0.2),
                                      const Color(0xFFFBC02D).withOpacity(0.05),
                                    ]
                                    : [
                                      Colors.white.withOpacity(0.12),
                                      Colors.white.withOpacity(0.05),
                                    ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isMainFamily
                                    ? const Color(0xFFFBC02D).withOpacity(0.4)
                                    : Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
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
                                                heading: displayName,
                                                hindiHeading:
                                                    '(वंशावली - परिवार वृक्ष)',
                                                totalMembers: family['members'],
                                              ),
                                        ),
                                      );
                                    },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            isMainFamily
                                                ? [
                                                  const Color(0xFFFBC02D),
                                                  const Color(0xFFF57F17),
                                                ]
                                                : [
                                                  Colors.blue.shade300,
                                                  Colors.blue.shade600,
                                                ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isMainFamily
                                                  ? Colors.orange
                                                  : Colors.blue)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isMainFamily
                                          ? Icons.family_restroom_rounded
                                          : Icons.diversity_3_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                displayName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                  shadows: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (isMainFamily)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFBC02D,
                                                  ).withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFFBC02D,
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'MAIN',
                                                  style: TextStyle(
                                                    color: Color(0xFFFBC02D),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_rounded,
                                              size: 14,
                                              color: Colors.white.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              family['head'] ?? 'Unknown Head',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              width: 4,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.4,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '${family['members']} Members',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ],
                              ),
                            ),
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
