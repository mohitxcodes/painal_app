import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painal/screens/vanshavali/more-family/AddFamilyDrawer.dart';
import 'package:painal/screens/vanshavali/more-family/FamilyTreeScreen.dart';
import 'package:provider/provider.dart';
import 'package:painal/apis/AuthProviderUser.dart';

class MoreFamilyScreen extends StatefulWidget {
  const MoreFamilyScreen({super.key});

  @override
  State<MoreFamilyScreen> createState() => _MoreFamilyScreenState();
}

class _MoreFamilyScreenState extends State<MoreFamilyScreen> {

  Future<List<Map<String, dynamic>>> fetchFamilies() async {
    // Fetch all families from the 'families' root collection
    final familiesSnapshot =
        await FirebaseFirestore.instance.collection('families').get();
    final List<Map<String, dynamic>> families = [];
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
      families.add({
        'collection': collectionName,
        'name': collectionName,
        'head': head['name'] ?? data['headName'] ?? '',
        'members': membersCountSnapshot.docs.length,
        'profilePhoto': head['profilePhoto'] ?? data['profilePhoto'] ?? '',
      });
    }
    return families;
  }

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
              setState(() {}); // Refetch families after drawer closes
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Vanshavali'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProviderUser>(
        builder: (context, authProvider, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchFamilies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final families = snapshot.data ?? [];
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: families.length + 1,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Add Family button at the top
                    if (authProvider.isAdmin) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Add Family',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: _openAddFamilyDrawer,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                  final family = families[index - 1];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade50,
                          radius: 28,
                          backgroundImage:
                              (family['profilePhoto'] != null &&
                                      family['profilePhoto'].isNotEmpty)
                                  ? NetworkImage(family['profilePhoto'])
                                  : null,
                          child:
                              (family['profilePhoto'] == null ||
                                      family['profilePhoto'].isEmpty)
                                  ? Icon(
                                    Icons.family_restroom,
                                    color: Colors.green.shade700,
                                    size: 32,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(family['head'] as String?)?.split(' ').first ?? ''} Family',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                family['head'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${family['members']} Members',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green, width: 2),
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => FamilyTreeScreen(
                                  onSearchPressed: () {},
                                  collectionName: family['collection'],
                                  heading: 'Vanshavali',
                                  hindiHeading: '(वंशावली - परिवार वृक्ष)',
                                  totalMembers: family['members'],
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'View',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
