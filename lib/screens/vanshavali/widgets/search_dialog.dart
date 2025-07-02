import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';
import 'dart:ui';

class SearchDialog extends StatefulWidget {
  final List<FamilyMember> familyData;
  final void Function(FamilyMember) onMemberSelected;

  const SearchDialog({
    Key? key,
    required this.familyData,
    required this.onMemberSelected,
  }) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  String query = '';
  List<FamilyMember> results = [];

  void updateResults(String value) {
    setState(() {
      query = value;
      if (query.isEmpty) {
        results = [];
      } else {
        results =
            widget.familyData
                .where(
                  (m) =>
                      m.name.toLowerCase().contains(query.toLowerCase()) ||
                      m.hindiName.contains(query),
                )
                .toList();
      }
    });
  }

  Widget _highlightText(
    String text,
    String query, {
    TextStyle? style,
    TextStyle? highlightStyle,
  }) {
    if (query.isEmpty) return Text(text, style: style);
    final lower = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int idx;
    while ((idx = lower.indexOf(lowerQuery, start)) != -1) {
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: style));
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style:
              highlightStyle ??
              const TextStyle(
                backgroundColor: Color(0x33FFEB3B),
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
      start = idx + query.length;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }
    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(color: Colors.transparent),
        ),
        Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.withOpacity(0.4),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 440,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search by name...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 14,
                                ),
                                isDense: true,
                              ),
                              onChanged: updateResults,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:
                            query.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.family_restroom,
                                        color: Colors.green[200],
                                        size: 48,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Start typing to search for a family member',
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : results.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sentiment_dissatisfied,
                                        color: Colors.grey[400],
                                        size: 40,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'No family members found',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.separated(
                                  itemCount: results.length,
                                  separatorBuilder:
                                      (_, __) => const Divider(
                                        height: 1,
                                        color: Color(0xFFE0E0E0),
                                      ),
                                  itemBuilder: (context, idx) {
                                    final member = results[idx];
                                    final parent =
                                        member.parentId != null
                                            ? widget.familyData.firstWhere(
                                              (m) => m.id == member.parentId,
                                              orElse:
                                                  () => FamilyMember(
                                                    id: -1,
                                                    name: 'No parent',
                                                    hindiName: '',
                                                    birthYear: '',
                                                    children: [],
                                                    profilePhoto: '',
                                                  ),
                                            )
                                            : null;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.green[100],
                                        backgroundImage:
                                            member.profilePhoto.isNotEmpty
                                                ? NetworkImage(
                                                  member.profilePhoto,
                                                )
                                                : null,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _highlightText(
                                            member.name,
                                            query,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          _highlightText(
                                            member.hindiName,
                                            query,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle:
                                          parent != null && parent.id != -1
                                              ? Text(
                                                'Parent: \\${parent.name}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              )
                                              : const Text(
                                                'No parent',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black38,
                                                ),
                                              ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onMemberSelected(member);
                                      },
                                    );
                                  },
                                ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        bottom: 10,
                        top: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => Navigator.of(context).pop(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
