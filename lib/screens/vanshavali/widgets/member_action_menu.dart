import 'package:flutter/material.dart';
import 'package:painal/screens/vanshavali/widgets/add_child_request_drawer.dart';

class MemberActionMenu extends StatelessWidget {
  final VoidCallback onAddChild;
  final VoidCallback onReportError;
  final String parentName;
  final int parentId;

  const MemberActionMenu({
    super.key,
    required this.onAddChild,
    required this.onReportError,
    required this.parentName,
    required this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 80,
            left: 12,
            right: 12,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.green,
                  size: 28,
                ),
                title: const Text(
                  'Add as Child',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                subtitle: Text(
                  'Request to add a child for $parentName. You will be asked to provide details for the new child.',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder:
                        (context) => AddChildRequestDrawer(
                          parentId: parentId,
                          parentName: parentName,
                        ),
                  );
                },
              ),
              const Divider(height: 0, thickness: 1, indent: 12, endIndent: 12),
              ListTile(
                leading: const Icon(
                  Icons.report_gmailerrorred_outlined,
                  color: Colors.red,
                  size: 28,
                ),
                title: const Text(
                  'Report Error',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                subtitle: const Text(
                  'Report issues like typing mistakes, wrong profile photo, incorrect date of birth, etc.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onReportError();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
