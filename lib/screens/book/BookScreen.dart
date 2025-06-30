import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final int totalPages = 5;
  int currentPage = 0;
  final PageController _pageController = PageController();
  bool isFullscreen = false;

  // Replace with your own image URLs if desired
  final List<String> pageImageUrls = [
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1750994812/lhx1jyi5pau2jxrd3kbx.jpg',
  ];

  void _jumpToPage() async {
    final controller = TextEditingController();
    int? selectedPage = await showDialog<int>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Jump to Page'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter page number'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final page = int.tryParse(controller.text);
                  if (page != null && page > 0 && page <= totalPages) {
                    Navigator.pop(context, page - 1);
                  }
                },
                child: const Text('Go'),
              ),
            ],
          ),
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
      backgroundColor: Colors.white,
      appBar:
          isFullscreen
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Painal Village Book',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            letterSpacing: 0.2,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.fullscreen,
                                            color: Colors.green,
                                            size: 22,
                                          ),
                                          onPressed:
                                              () => setState(
                                                () => isFullscreen = true,
                                              ),
                                          tooltip: 'Fullscreen',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.search,
                                            color: Colors.green,
                                            size: 22,
                                          ),
                                          tooltip: 'Search',
                                          onPressed: () {
                                            /* TODO: Add search functionality */
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 0),
                                    const Text(
                                      'पैनाल गाँव पुस्तक',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                        letterSpacing: 0.1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const Text(
                                  'Total Pages: ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '$totalPages',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                const Text(
                                  'Current Page: ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${currentPage + 1}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 0),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFE0E0E0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: totalPages,
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.white),
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
                (context, event) =>
                    const Center(child: CircularProgressIndicator()),
          ),
          if (!isFullscreen)
            Positioned(
              bottom: 24,
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
              top: 40,
              right: 20,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: 'Exit Fullscreen',
                  onPressed: () => setState(() => isFullscreen = false),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
