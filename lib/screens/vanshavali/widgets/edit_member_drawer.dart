import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/apis/UploadImage.dart';
import 'package:hive/hive.dart';

class EditMemberDrawer extends StatefulWidget {
  final FamilyMember member;
  final VoidCallback? onSaved;

  const EditMemberDrawer({super.key, required this.member, this.onSaved});

  @override
  State<EditMemberDrawer> createState() => _EditMemberDrawerState();
}

class _EditMemberDrawerState extends State<EditMemberDrawer> {
  late TextEditingController nameController;
  late TextEditingController hindiNameController;
  late TextEditingController dobController;
  String? uploadedPhotoUrl;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.member.name);
    hindiNameController = TextEditingController(text: widget.member.hindiName);
    dobController = TextEditingController(text: widget.member.birthYear);
    uploadedPhotoUrl = widget.member.profilePhoto;
  }

  @override
  void dispose() {
    nameController.dispose();
    hindiNameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => loading = true);
    try {
      await FirebaseFirestore.instance
          .collection('familyMembers')
          .doc(widget.member.id.toString())
          .update({
            'name': nameController.text.trim(),
            'hindiName': hindiNameController.text.trim(),
            'birthYear': dobController.text.trim(),
            'profilePhoto': uploadedPhotoUrl ?? '',
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      // --- Hive update ---
      final box = Hive.box<FamilyMember>('familyBox');
      final updatedMember = FamilyMember(
        id: widget.member.id,
        name: nameController.text.trim(),
        hindiName: hindiNameController.text.trim(),
        birthYear: dobController.text.trim(),
        children: widget.member.children,
        parentId: widget.member.parentId,
        profilePhoto: uploadedPhotoUrl ?? '',
      );
      await box.put(widget.member.id, updatedMember);
      // --- End Hive update ---
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member updated successfully!')),
        );
        widget.onSaved?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
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
            'Edit Member',
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
              labelText: 'Birth Year',
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
                        'Save Changes',
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
