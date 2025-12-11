import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:ui';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  // Replace with your own image URLs if desired
  final List<String> pageImageUrls = [
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-2.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-3.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-4.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-5.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-6.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-7.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-8.jpg",
    "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748/page-9.jpg",
  ];

  final int totalPages = 9;
  int currentPage = 0;
  final PageController _pageController = PageController();
  bool isFullscreen = false;

  void _showSearchDialog() async {
    final controller = TextEditingController();
    int? selectedPage = await showDialog<int>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
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
                          color: Colors.green.withOpacity(0.6),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                          maxHeight: 220,
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
                                      controller: controller,
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter page number...',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 14,
                                            ),
                                        isDense: true,
                                        errorText: errorText,
                                        errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
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
                                      onTap: () {
                                        final page = int.tryParse(
                                          controller.text,
                                        );
                                        if (page == null ||
                                            page < 1 ||
                                            page > totalPages) {
                                          setState(() {
                                            errorText =
                                                'Enter a valid page (1-$totalPages)';
                                          });
                                        } else {
                                          Navigator.of(context).pop(page - 1);
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          'Go',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Material(
                                    color: Colors.red[200],
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
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
          },
        );
      },
    );
    if (selectedPage != null) {
      _pageController.jumpToPage(selectedPage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          isFullscreen
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF0B3B2D).withOpacity(0.95),
                          const Color(0xFF155D42).withOpacity(0.85),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Village Book',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        '(गाँव पुस्तक)',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4ADE80),
                                          letterSpacing: 0.1,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Total Pages: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '$totalPages',
                                  style: const TextStyle(
                                    color: Color(0xFF4ADE80),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                const Text(
                                  'Current Page: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${currentPage + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF4ADE80),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Color(0xFF4ADE80),
                                    size: 22,
                                  ),
                                  onPressed:
                                      () => setState(() => isFullscreen = true),
                                  tooltip: 'Fullscreen',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    size: 26,
                                    color: Color(0xFF4ADE80),
                                    weight: 900, // Flutter 3.10+
                                  ),
                                  tooltip: 'Search',
                                  onPressed: _showSearchDialog,
                                ),
                              ],
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
            stops: [0.0, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                pageController: _pageController,
                itemCount: totalPages,
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(pageImageUrls[index]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3.0,
                    heroAttributes: PhotoViewHeroAttributes(tag: 'page_$index'),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                scrollDirection: Axis.horizontal,
                loadingBuilder:
                    (context, event) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
              ),
              if (!isFullscreen)
                Positioned(
                  bottom: 34,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Page ${currentPage + 1} of $totalPages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              if (isFullscreen)
                Positioned(
                  top: 20,
                  right: 20,
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                          size: 36,
                        ),
                        tooltip: 'Exit Fullscreen',
                        onPressed: () => setState(() => isFullscreen = false),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
