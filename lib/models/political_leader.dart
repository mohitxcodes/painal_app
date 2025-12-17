class PoliticalLeader {
  final String name;
  final String englishName;
  final String position;
  final String imageUrl;
  final String? achievements;
  final String? party;
  final String place;

  PoliticalLeader({
    required this.name,
    required this.englishName,
    required this.position,
    required this.imageUrl,
    required this.place,
    this.achievements,
    this.party,
  });
}
