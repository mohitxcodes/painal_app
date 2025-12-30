import 'package:flutter/material.dart';
import 'package:painal/data/BookPageData.dart';

class BookSearchGridScreen extends StatefulWidget {
  final BookPageData bookData;

  const BookSearchGridScreen({super.key, required this.bookData});

  @override
  State<BookSearchGridScreen> createState() => _BookSearchGridScreenState();
}

class _BookSearchGridScreenState extends State<BookSearchGridScreen> {
  late List<int> _filteredIndices;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredIndices = List.generate(
      widget.bookData.pageImageUrls.length,
      (i) => i,
    );
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _filteredIndices = List.generate(
            widget.bookData.pageImageUrls.length,
            (i) => i,
          );
        });
      }
      return;
    }

    // Filter logic: Check if (page index + 1) contains the query text
    // E.g. Query "1" matches Page 1, Page 10, Page 12, etc.
    final filtered = <int>[];
    for (int i = 0; i < widget.bookData.pageImageUrls.length; i++) {
      final pageNumStr = (i + 1).toString();
      if (pageNumStr.contains(query)) {
        filtered.add(i);
      }
    }

    if (mounted) {
      setState(() {
        _filteredIndices = filtered;
      });
    }
  }

  String _getOptimizedUrl(String url) {
    if (url.contains('cloudinary.com') && url.contains('/upload/')) {
      // For grid thumbnails, we can optimize even more if needed,
      // but sticking to f_auto,q_auto is good for consistency.
      return url.replaceFirst('/upload/', '/upload/f_auto,q_auto/');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
          stops: [0.0, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Container(
            height: 48, // Fixed height for search bar
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              cursorColor: const Color(0xFF4ADE80),
              decoration: InputDecoration(
                hintText: 'Search page number...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => _searchController.clear(),
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
        body:
            _filteredIndices.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.find_in_page_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No pages found',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                : Scrollbar(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3, // Portrait aspect ratio
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _filteredIndices.length,
                    itemBuilder: (context, index) {
                      final originalIndex = _filteredIndices[index];
                      final imageUrl =
                          widget.bookData.pageImageUrls[originalIndex];
                      final pageNumber = originalIndex + 1;

                      return GestureDetector(
                        onTap: () {
                          // Return the selected page index
                          Navigator.of(context).pop(originalIndex);
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  _getOptimizedUrl(imageUrl),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                        strokeWidth: 2,
                                        color: const Color(0xFF4ADE80),
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: Colors.white.withOpacity(0.1),
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Page $pageNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
