import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:painal/apis/UploadImage.dart';

class AddChildRequestDrawer extends StatefulWidget {
  final int parentId;
  final String parentName;
  const AddChildRequestDrawer({
    super.key,
    required this.parentId,
    required this.parentName,
  });

  @override
  State<AddChildRequestDrawer> createState() => _AddChildRequestDrawerState();
}

class _AddChildRequestDrawerState extends State<AddChildRequestDrawer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hindiNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? _uploadedImageUrl;
  bool _loading = false;

  @override
  void dispose() {
    nameController.dispose();
    hindiNameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final url = await pickAndUploadImage();
    Navigator.of(context).pop();
    if (url != null && url.isNotEmpty) {
      setState(() {
        _uploadedImageUrl = url;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile photo uploaded!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image upload failed.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _uploadImage() async {
    // Deprecated: use pickAndUploadImage directly
    return null;
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();
    final hindiName = hindiNameController.text.trim();
    final dob = dobController.text.trim();
    if (name.isEmpty || hindiName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and Hindi Name are required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    String? imageUrl = _uploadedImageUrl;
    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'parentId': widget.parentId,
        'parentName': widget.parentName,
        'name': name,
        'hindiName': hindiName,
        'dob': dob,
        'profilePhoto': imageUrl ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
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
                      'Request Sent!',
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
                      'Your request to add "$name" as a child of "${widget.parentName}" has been sent.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'If all details are correct, it will be added within 3 days.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: viewInsets.bottom > 0 ? viewInsets.bottom : 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 38,
                              backgroundColor: Colors.green[100],
                              backgroundImage:
                                  _uploadedImageUrl != null &&
                                          _uploadedImageUrl!.isNotEmpty
                                      ? NetworkImage(_uploadedImageUrl!)
                                      : null,
                              child:
                                  _uploadedImageUrl == null ||
                                          _uploadedImageUrl!.isEmpty
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
                                  onTap: _pickAndUploadImage,
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
                      const SizedBox(height: 18),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'English Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: hindiNameController,
                        decoration: InputDecoration(
                          labelText: 'Hindi Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.cake),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          icon:
                              _loading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : const Icon(Icons.send),
                          label: const Text('Send Request'),
                          onPressed: _loading ? null : _submit,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Cancel'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
