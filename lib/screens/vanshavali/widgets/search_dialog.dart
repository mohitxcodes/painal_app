import 'package:flutter/material.dart';
import 'package:painal/models/FamilyMember.dart';
import 'dart:ui';
import 'package:photo_view/photo_view.dart';

class SearchDialog extends StatefulWidget {
  final List<FamilyMember> familyData;
  final void Function(FamilyMember) onMemberSelected;

  const SearchDialog({
    super.key,
    required this.familyData,
    required this.onMemberSelected,
  });

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
        final isNumeric = int.tryParse(query) != null;
        results =
            widget.familyData.where((m) {
              final matchesName = m.name.toLowerCase().contains(
                query.toLowerCase(),
              );
              final matchesHindi = m.hindiName.contains(query);
              final matchesId = isNumeric && m.id.toString().contains(query);
              return matchesName || matchesHindi || matchesId;
            }).toList();
      }
    });
  }

  void _showProfileImage(
    BuildContext context,
    String imageUrl,
    String memberName,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              children: [
                PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3.0,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: 'search_profile_$memberName',
                  ),
                  loadingBuilder:
                      (context, event) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                ),
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
                  maxHeight: 500,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.green[700],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Search Family Members',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search by name, Hindi name...',
                              prefixIcon: Icon(
                                Icons.person_search,
                                color: Colors.green[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green[600]!,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            onChanged: updateResults,
                          ),
                        ],
                      ),
                    ),
                    // Results
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
                                        size: 64,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Start typing to search',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Search by English name, Hindi name...',
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
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
                                        size: 48,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No results found',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Try different keywords',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
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
                                        color: Color(0xFFE8E8E8),
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
                                                    name: 'Unknown',
                                                    hindiName: '',
                                                    birthYear: '',
                                                    children: [],
                                                    profilePhoto: '',
                                                  ),
                                            )
                                            : null;
                                    final children = member.childMembers;

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            widget.onMemberSelected(member);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                // Profile Image
                                                GestureDetector(
                                                  onTap:
                                                      member
                                                              .profilePhoto
                                                              .isNotEmpty
                                                          ? () =>
                                                              _showProfileImage(
                                                                context,
                                                                member
                                                                    .profilePhoto,
                                                                member.name,
                                                              )
                                                          : null,
                                                  child: Hero(
                                                    tag:
                                                        'search_profile_${member.name}',
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Colors.green[100],
                                                        border: Border.all(
                                                          color:
                                                              Colors
                                                                  .green[300]!,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child:
                                                          member
                                                                  .profilePhoto
                                                                  .isNotEmpty
                                                              ? ClipOval(
                                                                child: Image.network(
                                                                  member
                                                                      .profilePhoto,
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                  errorBuilder:
                                                                      (
                                                                        context,
                                                                        error,
                                                                        stackTrace,
                                                                      ) => Icon(
                                                                        Icons
                                                                            .person,
                                                                        color:
                                                                            Colors.green[600],
                                                                        size:
                                                                            24,
                                                                      ),
                                                                ),
                                                              )
                                                              : Icon(
                                                                Icons.person,
                                                                color:
                                                                    Colors
                                                                        .green[600],
                                                                size: 24,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                // Member Info
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Name
                                                      _highlightText(
                                                        member.name,
                                                        query,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),

                                                      const SizedBox(height: 2),
                                                      // Hindi Name
                                                      _highlightText(
                                                        member.hindiName,
                                                        query,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.green[700],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      if (parent != null &&
                                                          parent.id != -1) ...[
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors.blue[50],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            'Father: ${parent.name}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors
                                                                      .blue[600],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                // Arrow
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Colors.green[600],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                    // Footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (results.isNotEmpty)
                            Text(
                              '${results.length} result${results.length == 1 ? '' : 's'} found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          Material(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Navigator.of(context).pop(),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
