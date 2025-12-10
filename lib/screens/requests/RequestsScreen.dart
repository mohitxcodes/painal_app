import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool _loading = false;

  Future<void> _approveRequest(DocumentSnapshot request) async {
    final data = request.data() as Map<String, dynamic>;
    final name = data['name'] ?? '';
    final parentName = data['parentName'] ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF0B3B2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Confirm Approval',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to add $name as a child of $parentName?',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: const Color(0xFF0B3B2D),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    setState(() => _loading = true);
    try {
      final parentId = data['parentId'];
      final hindiName = data['hindiName'];
      final dob = data['dob'];
      final profilePhoto = data['profilePhoto'] ?? '';
      final familyMembers =
          await FirebaseFirestore.instance.collection('familyMembers').get();
      int maxId = 0;
      for (var doc in familyMembers.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) maxId = id;
      }
      final newId = maxId + 1;
      await FirebaseFirestore.instance
          .collection('familyMembers')
          .doc(newId.toString())
          .set({
            'id': newId,
            'name': name,
            'hindiName': hindiName,
            'birthYear': dob,
            'children': <int>[],
            'parentId': parentId,
            'profilePhoto': profilePhoto,
          });
      final parentDoc =
          await FirebaseFirestore.instance
              .collection('familyMembers')
              .doc(parentId.toString())
              .get();
      if (parentDoc.exists) {
        final parentData = parentDoc.data() as Map<String, dynamic>;
        final children = List<int>.from(parentData['children'] ?? []);
        children.add(newId);
        await FirebaseFirestore.instance
            .collection('familyMembers')
            .doc(parentId.toString())
            .update({'children': children});
      }
      await request.reference.delete();
      if (mounted) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: const Color(0xFF0B3B2D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                titlePadding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                ),
                title: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Member Added!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Member "$name" has been added as a child of "$parentName".',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: const Color(0xFF0B3B2D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Request approved and member added!'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteRequest(DocumentSnapshot request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF0B3B2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Delete Request',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to delete this request?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (confirm == true) {
      try {
        await request.reference.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Request deleted.'),
              backgroundColor: Colors.green[700],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
          title: const Text(
            'Requests',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:
            _loading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('requests')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No requests found.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    final requests = snapshot.data!.docs;
                    return ListView.separated(
                      padding: const EdgeInsets.all(18),
                      itemCount: requests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (context, i) {
                        final data = requests[i].data() as Map<String, dynamic>;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              width: 2,
                                            ),
                                            image:
                                                (data['profilePhoto'] != null &&
                                                        data['profilePhoto']
                                                            .toString()
                                                            .isNotEmpty)
                                                    ? DecorationImage(
                                                      image: NetworkImage(
                                                        data['profilePhoto'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                    : null,
                                          ),
                                          child:
                                              (data['profilePhoto'] == null ||
                                                      data['profilePhoto']
                                                          .toString()
                                                          .isEmpty)
                                                  ? const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 28,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: data['name'] ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                  children: [
                                                    if ((data['hindiName'] ??
                                                            '')
                                                        .toString()
                                                        .isNotEmpty)
                                                      TextSpan(
                                                        text:
                                                            ' (${data['hindiName']})',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white
                                                              .withOpacity(0.7),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              if ((data['dob'] ?? '')
                                                  .toString()
                                                  .isNotEmpty)
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.cake,
                                                      size: 16,
                                                      color:
                                                          Colors.orangeAccent,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'DOB: ${data['dob']}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white
                                                            .withOpacity(0.85),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.family_restroom,
                                                    size: 16,
                                                    color: Colors.white70,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      'Parent: ${data['parentName'] ?? ''}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white
                                                            .withOpacity(0.85),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '(ID: ${data['parentId'] ?? ''})',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (data['timestamp'] != null &&
                                        data['timestamp'] is Timestamp)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          (data['timestamp'] as Timestamp)
                                              .toDate()
                                              .toString()
                                              .split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 5,
                                                sigmaY: 5,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.greenAccent
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.greenAccent
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(
                                                    Icons.check_circle,
                                                    size: 20,
                                                  ),
                                                  label: const Text(
                                                    'Approve',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    foregroundColor:
                                                        Colors.greenAccent,
                                                    elevation: 0,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed:
                                                      _loading
                                                          ? null
                                                          : () =>
                                                              _approveRequest(
                                                                requests[i],
                                                              ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 5,
                                                sigmaY: 5,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                    0.2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.redAccent
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    size: 20,
                                                  ),
                                                  label: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    foregroundColor:
                                                        Colors.redAccent,
                                                    elevation: 0,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed:
                                                      _loading
                                                          ? null
                                                          : () =>
                                                              _deleteRequest(
                                                                requests[i],
                                                              ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      ),
    );
  }
}
