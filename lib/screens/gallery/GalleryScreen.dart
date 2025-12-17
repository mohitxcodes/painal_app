import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<String> galleryImages = [
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765963937/img.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765963937/img-2.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765963937/img-3.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765963937/img-4.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765963937/img-5.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765964096/img-6.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765964096/img.jpg',
    'https://res.cloudinary.com/mohitxcodes/image/upload/v1765964096/img-2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0B3B2D), Color(0xFF155D42)],
                  stops: [0.0, 1.0],
                ),
              ),
              child: FlexibleSpaceBar(
                title: const Text(
                  'Village Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // Gallery Grid
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverToBoxAdapter(child: _buildBentoGrid()),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0, // Square tiles
      ),
      itemCount: galleryImages.length,
      itemBuilder: (context, index) {
        return _buildGalleryTile(imageUrl: galleryImages[index], index: index);
      },
    );
  }

  Widget _buildGalleryTile({required String imageUrl, required int index}) {
    return GestureDetector(
      onTap: () => _openImageViewer(index),
      child: Hero(
        tag: 'image_$index',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green[400]!,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    );
                  },
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openImageViewer(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => _ImageViewerScreen(
              imageUrl: galleryImages[index],
              tag: 'image_$index',
            ),
      ),
    );
  }
}

// Full-screen image viewer
class _ImageViewerScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const _ImageViewerScreen({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
