class BookPageData {
  static const String _baseUrl =
      "https://res.cloudinary.com/mohitxcodes/image/upload/v1751433748";

  final List<String> pageImageUrls = [
    "$_baseUrl/page-346.jpg",
    "$_baseUrl/page-347.jpg",
    "$_baseUrl/page.jpg",
    ...List.generate(
      344, // Generates pages 2 to 345 (344 items)
      (index) => "$_baseUrl/page-${index + 2}.jpg",
    ),
  ];
}
