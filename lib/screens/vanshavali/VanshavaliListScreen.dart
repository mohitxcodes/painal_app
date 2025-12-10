import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/VanshavaliScreen.dart';
import 'package:painal/screens/vanshavali/widgets/search_dialog.dart';

// Main family data
Map<String, dynamic> mainFamily = {
  'id': 'main_family',
  'name': 'Primary Family',
  'relation': 'Primary Family Tree',
  'collection': 'familyMembers', // Default collection for main family
  'icon': Icons.family_restroom_rounded,
  'isMain': true,
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
  bool _isLoading = true;
  String _errorMessage = '';

  // Search related
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load families from cache first, then fetch background update if needed
    _loadFamilies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    if (familyMembers.isEmpty) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      // 1. Fetch Main Family Config
      final mainFamilyIndex = familyMembers.indexWhere(
        (f) => f['isMain'] == true,
      );

      Map<String, dynamic> currentMainFamily;
      if (mainFamilyIndex != -1) {
        currentMainFamily = familyMembers[mainFamilyIndex];
      } else {
        currentMainFamily = Map<String, dynamic>.from(mainFamily);
      }

      // 2. Fetch List of ALL Families
      final familiesSnapshot = await FirebaseFirestore.instance
          .collection('families')
          .get()
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      final List<Map<String, dynamic>> fetchedFamilies = [];

      for (final doc in familiesSnapshot.docs) {
        final data = doc.data();
        final collectionName = data['collectionName'] as String?;
        if (collectionName == null) continue;

        fetchedFamilies.add({
          'id': doc.id,
          'collection': collectionName,
          'name': data['name'] ?? collectionName,
          'relation': data['relation'] ?? 'Family Branch',
          'isMain': false,
          'members': 0, // Placeholder, will be fetched below
        });
      }

      // 3. Fetch member counts for all families in parallel
      final List<Future<void>> countFutures = [];

      // Main family count
      countFutures.add(
        FirebaseFirestore.instance
            .collection(currentMainFamily['collection'] ?? 'familyMembers')
            .count()
            .get()
            .then((snapshot) {
              if (mounted) {
                currentMainFamily['members'] = snapshot.count ?? 0;
              }
            })
            .catchError((e) {
              debugPrint('Error fetching main family count: $e');
              currentMainFamily['members'] = 0;
            }),
      );

      // Other families counts
      for (final family in fetchedFamilies) {
        final collectionName = family['collection'] as String;
        countFutures.add(
          FirebaseFirestore.instance
              .collection(collectionName)
              .count()
              .get()
              .then((snapshot) {
                if (mounted) {
                  family['members'] = snapshot.count ?? 0;
                }
              })
              .catchError((e) {
                debugPrint('Error fetching count for $collectionName: $e');
                family['members'] = 0;
              }),
        );
      }

      // Wait for all counts to complete
      await Future.wait(countFutures);

      if (!mounted) return;

      // 4. Render and Update Cache
      setState(() {
        final otherFamilies =
            fetchedFamilies.where((f) => f['isMain'] != true).toList();
        familyMembers = [currentMainFamily, ...otherFamilies];
        _isLoading = false;
      });

      if (updateCache) {
        try {
          var box = await Hive.openBox('vanshavali_list_cache');
          await box.put('families', familyMembers);
        } catch (e) {
          print("Cache save error: $e");
        }
      }
    } catch (e) {
      if (mounted && familyMembers.isEmpty) {
        setState(() {
          _errorMessage = 'Failed to load family list.';
          _isLoading = false;
        });
      }
      debugPrint("Error fetching families: $e");
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
              _navigateWithAnimation(
                VanshavaliScreen(
                  initialMemberId: member.id,
                  isMainFamily: true,
                ),
              );
            } else {
              // Find family details for the screen title
              final family = familyMembers.firstWhere(
                (f) => f['collection'] == member.collectionName,
                orElse: () => {},
              );

              final heading = family['name'] ?? 'Family Tree';

              _navigateWithAnimation(
                VanshavaliScreen(
                  collectionName: member.collectionName!,
                  heading: heading,
                  hindiHeading: '(वंशावली - परिवार वृक्ष)',
                  initialMemberId: member.id,
                  isMainFamily: false,
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
      // Fetch all members from collection (with caching this is fast)
      final snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      final allMembers =
          snapshot.docs.map((doc) {
            final member = FamilyMember.fromMap(doc.data());
            member.collectionName = collectionName;
            return member;
          }).toList();

      // Filter locally for case-insensitive substring search
      final lowerQuery = query.toLowerCase();
      final isNumeric = int.tryParse(query) != null;

      final results =
          allMembers.where((member) {
            // Search in English name (case-insensitive)
            final matchesEnglishName = member.name.toLowerCase().contains(
              lowerQuery,
            );

            // Search in Hindi name (case-insensitive)
            final matchesHindiName = member.hindiName.toLowerCase().contains(
              lowerQuery,
            );

            // Search by ID
            final matchesId = isNumeric && member.id.toString().contains(query);

            // Search in father's name if available
            bool matchesFatherName = false;
            if (member.parentId != null) {
              final parent = allMembers.firstWhere(
                (m) => m.id == member.parentId,
                orElse:
                    () => FamilyMember(
                      id: -1,
                      name: '',
                      hindiName: '',
                      birthYear: '',
                      children: [],
                      profilePhoto: '',
                    ),
              );
              if (parent.id != -1) {
                matchesFatherName =
                    parent.name.toLowerCase().contains(lowerQuery) ||
                    parent.hindiName.toLowerCase().contains(lowerQuery);
              }
            }

            return matchesEnglishName ||
                matchesHindiName ||
                matchesId ||
                matchesFatherName;
          }).toList();

      // Populate parent names for display
      for (var member in results) {
        if (member.parentId != null) {
          final parent = allMembers.firstWhere(
            (m) => m.id == member.parentId,
            orElse:
                () => FamilyMember(
                  id: -1,
                  name: '',
                  hindiName: '',
                  birthYear: '',
                  children: [],
                  profilePhoto: '',
                ),
          );
          if (parent.id != -1) {
            member.parentName = parent.name;
            member.parentHindiName = parent.hindiName;
          }
        }
      }

      return results
          .take(10)
          .toList(); // Limit to top 10 results per collection
    } catch (e) {
      print('Error searching $collectionName: $e');
      return [];
    }
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

  @override
  Widget build(BuildContext context) {
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
          toolbarHeight: 100,
          title: _VanshavaliListHeader(
            onSearchPressed: _showSearchDialog,
            familyCount: familyMembers.length,
            totalMembers: familyMembers.fold<int>(
              0,
              (sum, family) => sum + ((family['members'] as int?) ?? 0),
            ),
          ),
        ),
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
                                      const VanshavaliScreen(
                                        isMainFamily: true,
                                      ), // Ensure fresh nav
                                    )
                                    : () {
                                      _navigateWithAnimation(
                                        VanshavaliScreen(
                                          collectionName: family['collection'],
                                          heading: displayName,
                                          hindiHeading:
                                              '(वंशावली - परिवार वृक्ष)',
                                          isMainFamily: false,
                                        ),
                                      );
                                    },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20, // Increased vertical padding
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                displayName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      18, // Increased size
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
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.people_outline,
                                              size: 14,
                                              color: Colors.white.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${family['members'] ?? 0} Members',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
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
}

class _VanshavaliListHeader extends StatelessWidget {
  final VoidCallback onSearchPressed;
  final int familyCount;
  final int totalMembers;

  const _VanshavaliListHeader({
    required this.onSearchPressed,
    required this.familyCount,
    required this.totalMembers,
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
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Text(
                '$familyCount families',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Text(
                '$totalMembers total members',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
