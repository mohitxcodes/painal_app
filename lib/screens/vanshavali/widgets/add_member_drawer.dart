import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/apis/UploadImage.dart';

class AddMemberDrawer extends StatefulWidget {
  final FamilyMember parent;
  final VoidCallback? onSaved;
  final List<FamilyMember> familyData;

  const AddMemberDrawer({
    Key? key,
    required this.parent,
    required this.familyData,
    this.onSaved,
  }) : super(key: key);

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
          .collection('familyMembers')
          .doc(newId.toString())
          .set({
            'id': newId,
            'name': name,
            'hindiName': hindiName,
            'birthYear': dob,
            'children': <int>[],
            'parentId': widget.parent.id,
            'profilePhoto': profilePhoto,
          });
      // Update parent's children list
      final updatedChildren = List<int>.from(widget.parent.children)
        ..add(newId);
      await FirebaseFirestore.instance
          .collection('familyMembers')
          .doc(widget.parent.id.toString())
          .update({'children': updatedChildren});
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
    return Padding(
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
                  backgroundColor: Colors.green[100],
                  backgroundImage:
                      (uploadedPhotoUrl != null && uploadedPhotoUrl!.isNotEmpty)
                          ? NetworkImage(uploadedPhotoUrl!)
                          : null,
                  child:
                      (uploadedPhotoUrl == null || uploadedPhotoUrl!.isEmpty)
                          ? const Icon(
                            Icons.person,
                            color: Colors.green,
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
                        child: Icon(Icons.edit, size: 20, color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add Family Member',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: hindiNameController,
            decoration: InputDecoration(
              labelText: 'Hindi Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: dobController,
            decoration: InputDecoration(
              labelText: 'Birth Year (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
    );
  }
}
