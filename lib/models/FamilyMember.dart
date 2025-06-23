class FamilyMember {
  final int id;
  final String name;
  final String hindiName;
  final String birthYear;
  final List<dynamic> children;
  final int? parentId;
  final String profilePhoto;

  FamilyMember({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.birthYear,
    required this.children,
    this.parentId,
    required this.profilePhoto,
  });

  factory FamilyMember.fromMap(Map<String, dynamic> data) {
    return FamilyMember(
      id: data['id'],
      name: data['name'],
      hindiName: data['hindiName'],
      birthYear: data['birthYear'],
      children: List<int>.from(data['children']),
      parentId: data['parentId'],
      profilePhoto: data['profilePhoto'],
    );
  }
}
