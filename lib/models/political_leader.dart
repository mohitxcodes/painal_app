class PoliticalLeader {
  final String name;
  final String position;
  final String imageUrl;
  final String tenure;
  final String? achievements;
  final String? party;

  PoliticalLeader({
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.tenure,
    this.achievements,
    this.party,
  });
}
