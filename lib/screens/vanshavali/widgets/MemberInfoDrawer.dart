import 'package:flutter/material.dart';
import 'package:painal/apis/AuthProviderUser.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/widgets/DrawerFamilyCard.dart';
import 'package:provider/provider.dart';
import 'package:painal/screens/vanshavali/widgets/member_action_menu.dart';
import 'package:painal/screens/vanshavali/widgets/report_error_drawer.dart';
import 'package:photo_view/photo_view.dart';

class MemberDetailsModal extends StatelessWidget {
  final FamilyMember member;
  final FamilyMember? parent;
  final List<FamilyMember> children;
  final List<FamilyMember> siblings;
  final VoidCallback onEdit;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final void Function(FamilyMember) onShowDetails;
  final ScrollController? scrollController;

  const MemberDetailsModal({
    super.key,
    required this.member,
    required this.parent,
    required this.children,
    required this.siblings,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
    required this.onShowDetails,
    this.scrollController,
  });

  void _showProfileImage(BuildContext context) {
    if (member.profilePhoto.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              children: [
                // Full screen photo view
                PhotoView(
                  imageProvider: NetworkImage(member.profilePhoto),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3.0,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: 'profile_${member.id}',
                  ),
                  loadingBuilder:
                      (context, event) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                ),
                // Close button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 20,
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthProviderUser>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showProfileImage(context),
                    child: Hero(
                      tag: 'profile_${member.id}',
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green[100],
                        backgroundImage:
                            member.profilePhoto.isNotEmpty
                                ? NetworkImage(member.profilePhoto)
                                : null,
                        child:
                            member.profilePhoto.isEmpty
                                ? const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                  size: 28,
                                )
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.hindiName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'जन्म fवर्ष: ${member.birthYear}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder:
                                      (context) => MemberActionMenu(
                                        onAddChild: onAdd,
                                        onReportError: () async {
                                          Navigator.of(context).pop();
                                          await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            builder:
                                                (context) => ReportErrorDrawer(
                                                  memberId: member.id,
                                                  memberName: member.hindiName,
                                                  memberNameEnglish:
                                                      member.name,
                                                  memberDob: member.birthYear,
                                                ),
                                          );
                                        },
                                        parentName: member.hindiName,
                                        parentId: member.id,
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (userAuth.isAdmin)
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: const Icon(Icons.edit, size: 20),
                        label: const Text('Edit'),
                        onPressed: onEdit,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline, size: 22),
                        label: const Text('Add'),
                        onPressed: onAdd,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 14),
              if (userAuth.isAdmin)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 22),
                    label: const Text('Delete'),
                    onPressed: onDelete,
                  ),
                ),
              if (userAuth.isAdmin) const SizedBox(height: 20),
              if (parent != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Father',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '(पिता)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MemberRectCard(
                      member: parent!,
                      onTap: () => onShowDetails(parent!),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              if (children.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Children',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '(बच्चे)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          children
                              .map(
                                (c) => MemberRectCard(
                                  member: c,
                                  onTap: () => onShowDetails(c),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              if (siblings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Siblings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '(भाई-बहन)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          siblings
                              .map(
                                (s) => MemberRectCard(
                                  member: s,
                                  onTap: () => onShowDetails(s),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
