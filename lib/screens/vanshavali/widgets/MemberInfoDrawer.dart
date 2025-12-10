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
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
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
                      color: Colors.white.withOpacity(0.3),
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
                          backgroundColor: Colors.white.withOpacity(0.1),
                          backgroundImage:
                              member.profilePhoto.isNotEmpty
                                  ? NetworkImage(member.profilePhoto)
                                  : null,
                          child:
                              member.profilePhoto.isEmpty
                                  ? const Icon(
                                    Icons.person,
                                    color: Colors.white70,
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
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      member.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    Text(
                                      'जन्म वर्ष: ${member.birthYear}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: const Color(0xFF0B3B2D),
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                              builder:
                                                  (context) =>
                                                      ReportErrorDrawer(
                                                        memberId: member.id,
                                                        memberName:
                                                            member.hindiName,
                                                        memberNameEnglish:
                                                            member.name,
                                                        memberDob:
                                                            member.birthYear,
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
                            backgroundColor: Colors.white.withOpacity(0.15),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
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
                            backgroundColor: Colors.white.withOpacity(0.15),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
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
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.red.withOpacity(0.3)),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Father',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(पिता)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Children',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(बच्चे)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:
                            children.map((c) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: MemberRectCard(
                                  member: c,
                                  onTap: () => onShowDetails(c),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                if (siblings.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Siblings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(भाई-बहन)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:
                            siblings.map((s) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: MemberRectCard(
                                  member: s,
                                  onTap: () => onShowDetails(s),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
