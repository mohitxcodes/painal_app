import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final FamilyMember member;
  final VoidCallback? onDeleted;
  final String collectionName;

  const DeleteConfirmationDialog({
    super.key,
    required this.member,
    required this.collectionName,
    this.onDeleted,
  });

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _loading = false;

  Future<void> _deleteMember() async {
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.member.id.toString())
          .delete();
      // Remove from parent's children list if parent exists
      if (widget.member.parentId != null) {
        final parentDoc =
            await FirebaseFirestore.instance
                .collection(widget.collectionName)
                .doc(widget.member.parentId.toString())
                .get();
        if (parentDoc.exists) {
          final parentData = parentDoc.data()!;
          final List<dynamic> children = List.from(
            parentData['children'] ?? [],
          );
          children.remove(widget.member.id);
          await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .doc(widget.member.parentId.toString())
              .update({
                'children': children,
                'lastUpdated': FieldValue.serverTimestamp(),
              });
        }
      }
      // --- Hive update ---
      final box = Hive.box<FamilyMember>('familyBox');
      await box.delete(widget.member.id);
      if (widget.member.parentId != null) {
        final parent = box.get(widget.member.parentId);
        if (parent != null) {
          final updatedChildren = List<int>.from(parent.children)
            ..remove(widget.member.id);
          final updatedParent = FamilyMember(
            id: parent.id,
            name: parent.name,
            hindiName: parent.hindiName,
            birthYear: parent.birthYear,
            children: updatedChildren,
            parentId: parent.parentId,
            profilePhoto: parent.profilePhoto,
          );
          await box.put(parent.id, updatedParent);
        }
      }
      // --- End Hive update ---
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member deleted successfully!')),
        );
        widget.onDeleted?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("----------------------${widget.collectionName}");
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          SizedBox(width: 10),
          Text('Confirm Deletion'),
        ],
      ),
      content: Text(
        'Are you sure you want to delete "${widget.member.name}"?\nThis action cannot be undone.',
        style: const TextStyle(fontSize: 15),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          onPressed: _loading ? null : _deleteMember,
          child:
              _loading
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : const Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
        ),
      ],
    );
  }
}
