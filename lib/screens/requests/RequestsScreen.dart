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
            title: const Text('Confirm Approval'),
            content: Text(
              'Are you sure you want to add $name as a child of $parentName?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                titlePadding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                ),
                title: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Member Added!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.green[800],
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
                      style: const TextStyle(fontSize: 16),
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
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
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
          const SnackBar(content: Text('Request approved and member added!')),
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
            title: const Text('Delete Request'),
            content: const Text(
              'Are you sure you want to delete this request?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Request deleted.')));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        backgroundColor: Colors.green[700],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('requests')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No requests found.'));
                  }
                  final requests = snapshot.data!.docs;
                  return ListView.separated(
                    padding: const EdgeInsets.all(18),
                    itemCount: requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, i) {
                      final data = requests[i].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.green[700]!,
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.green[100],
                                      backgroundImage:
                                          (data['profilePhoto'] != null &&
                                                  data['profilePhoto']
                                                      .toString()
                                                      .isNotEmpty)
                                              ? NetworkImage(
                                                data['profilePhoto'],
                                              )
                                              : null,
                                      child:
                                          (data['profilePhoto'] == null ||
                                                  data['profilePhoto']
                                                      .toString()
                                                      .isEmpty)
                                              ? const Icon(
                                                Icons.person,
                                                color: Colors.green,
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
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: data['name'] ?? '',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    children: [
                                                      if ((data['hindiName'] ??
                                                              '')
                                                          .toString()
                                                          .isNotEmpty)
                                                        TextSpan(
                                                          text:
                                                              ' (${data['hindiName']})',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
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
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'DOB: ${data['dob']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.family_restroom,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Parent: ${data['parentName'] ?? ''}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                '(ID: ${data['parentId'] ?? ''})',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (data['timestamp'] != null &&
                                        data['timestamp'] is Timestamp)
                                      Text(
                                        (data['timestamp'] as Timestamp)
                                            .toDate()
                                            .toString()
                                            .split(' ')[0],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Approve',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          _loading
                                              ? null
                                              : () =>
                                                  _approveRequest(requests[i]),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[600],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          _loading
                                              ? null
                                              : () =>
                                                  _deleteRequest(requests[i]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
