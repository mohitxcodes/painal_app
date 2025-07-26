import 'package:hive/hive.dart';

part 'FamilyMember.g.dart';

@HiveType(typeId: 1)
class FamilyMember {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String hindiName;

  @HiveField(3)
  final String birthYear;

  @HiveField(4)
  final List<int> children;

  @HiveField(5)
  final int? parentId;

  @HiveField(6)
  final String profilePhoto;

  @HiveField(7)
  List<FamilyMember> childMembers = [];

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
