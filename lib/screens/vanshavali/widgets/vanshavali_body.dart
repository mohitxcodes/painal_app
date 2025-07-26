import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';
import 'package:painal/screens/vanshavali/widgets/family_member_card.dart';

class VanshavaliBody extends StatelessWidget {
  final FamilyMember currentMember;
  final List<FamilyMember> navigationStack;
  final VoidCallback onNavigateBack;
  final void Function(FamilyMember) onNavigateToChild;
  final void Function(FamilyMember) onCardTap;

  const VanshavaliBody({
    super.key,
    required this.currentMember,
    required this.navigationStack,
    required this.onNavigateBack,
    required this.onNavigateToChild,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final contentInnerWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (navigationStack.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onNavigateBack,
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              label: const Text(
                'Back',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        // Main member card always full width
        SizedBox(
          width: contentInnerWidth,
          child: FamilyMemberCard(
            member: currentMember,
            onTap: () => onCardTap(currentMember),
          ),
        ),

        if (currentMember.childMembers.isNotEmpty) ...[
          // Draw vertical line
          Container(
            width: 2,
            height: 32,
            color: Colors.green[200],
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          // Children row scrollable inside the bordered area
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  currentMember.childMembers.map((child) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        FamilyMemberCard(
                          member: child,
                          onTap: () => onCardTap(child),
                        ),
                        Positioned(
                          child:
                              child.childMembers.isNotEmpty
                                  ? Material(
                                    color: Colors.green[700],
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () => onNavigateToChild(child),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                  : Material(
                                    color: Colors.red[200],
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'No children for this member.',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }, // Disabled navigation
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
