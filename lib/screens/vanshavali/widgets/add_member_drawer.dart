import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/apis/UploadImage.dart';
import 'package:hive/hive.dart';

class AddMemberDrawer extends StatefulWidget {
  final FamilyMember parent;
  final VoidCallback? onSaved;
  final List<FamilyMember> familyData;
  final String collectionName;

  const AddMemberDrawer({
    super.key,
    required this.parent,
    required this.familyData,
    required this.collectionName,
    this.onSaved,
  });

  @override
  State<AddMemberDrawer> createState() => _AddMemberDrawerState();
}

class _AddMemberDrawerState extends State<AddMemberDrawer> {
  final nameController = TextEditingController();
  final hindiNameController = TextEditingController();
  final dobController = TextEditingController();
  String? uploadedPhotoUrl;
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    hindiNameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final hindiName = hindiNameController.text.trim();
    final dob =
        dobController.text.trim().isEmpty
            ? 'Unavailable'
            : dobController.text.trim();
    final profilePhoto = uploadedPhotoUrl ?? '';
    if (name.isEmpty || hindiName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and Hindi Name are required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => loading = true);
    try {
      int maxId = 0;
      if (widget.familyData.isNotEmpty) {
        maxId = widget.familyData
            .map((m) => m.id)
            .reduce((a, b) => a > b ? a : b);
      }
      final newId = maxId + 1;
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(newId.toString())
          .set({
            'id': newId,
            'name': name,
            'hindiName': hindiName,
            'birthYear': dob,
            'children': <int>[],
            'parentId': widget.parent.id,
            'profilePhoto': profilePhoto,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      // Update parent's children list
      final updatedChildren = List<int>.from(widget.parent.children)
        ..add(newId);
      await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.parent.id.toString())
          .update({
            'children': updatedChildren,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      // --- Hive update ---
      final box = Hive.box<FamilyMember>('familyBox');
      final newMember = FamilyMember(
        id: newId,
        name: name,
        hindiName: hindiName,
        birthYear: dob,
        children: [],
        parentId: widget.parent.id,
        profilePhoto: profilePhoto,
      );
      await box.put(newId, newMember);
      // Update parent in Hive
      final parent = box.get(widget.parent.id);
      if (parent != null) {
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
      // --- End Hive update ---
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member added successfully!')),
        );
        widget.onSaved?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B3B2D), Color(0xFF1F6B3A)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    backgroundImage:
                        (uploadedPhotoUrl != null &&
                                uploadedPhotoUrl!.isNotEmpty)
                            ? NetworkImage(uploadedPhotoUrl!)
                            : null,
                    child:
                        (uploadedPhotoUrl == null || uploadedPhotoUrl!.isEmpty)
                            ? const Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 38,
                            )
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          );
                          final url = await pickAndUploadImage();
                          Navigator.of(context).pop();
                          if (url != null && url.isNotEmpty) {
                            setState(() {
                              uploadedPhotoUrl = url;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile photo uploaded!'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Image upload failed.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Add Family Member',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.person, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: hindiNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Hindi Name',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.translate, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: dobController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Birth Year (optional)',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.cake, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                ),
                onPressed: loading ? null : _save,
                child:
                    loading
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : const Text(
                          'Add Member',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
