import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  String _formatDate(Timestamp? ts) {
    if (ts == null) return '-';
    final dt = ts.toDate();
    return DateFormat('d MMM yyyy').format(dt);
  }

  Future<void> _deleteReport(BuildContext context, String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Report'),
            content: const Text('Are you sure you want to delete this report?'),
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
    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report deleted'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: const Text(
          'Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('reports')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No reports found.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              final hasCorrectName =
                  data['correctName'] != null &&
                  (data['correctName'] as String).isNotEmpty;
              final hasCorrectDob =
                  data['correctDob'] != null &&
                  (data['correctDob'] as String).isNotEmpty;
              return Container(
                margin: const EdgeInsets.only(
                  left: 6,
                  right: 0,
                  top: 0,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border(
                    left: BorderSide(
                      color:
                          hasCorrectName || hasCorrectDob
                              ? Colors.orange
                              : Colors.green,
                      width: 5,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.green,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Member ID: ${data['memberId'] ?? '-'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.badge,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Name: ${data['membername'] ?? '-'}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (hasCorrectName)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Correct Name:',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          data['correctName'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (hasCorrectDob)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.cake,
                                          color: Colors.orange,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Correct DOB:',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          data['correctDob'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Delete button (top right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red[700],
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: const Text('Delete'),
                        onPressed: () => _deleteReport(context, doc.id),
                      ),
                    ),
                    // Date (bottom right)
                    Positioned(
                      right: 16,
                      bottom: 10,
                      child: Text(
                        _formatDate(data['timestamp']),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
