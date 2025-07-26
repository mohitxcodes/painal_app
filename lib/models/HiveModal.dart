import 'package:hive/hive.dart';

part 'HiveModal.g.dart';

@HiveType(typeId: 0)
class PersonModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String hindiName;

  @HiveField(3)
  final int parentId;

  @HiveField(4)
  final int birthYear;

  @HiveField(5)
  final String profilePhoto;

  @HiveField(6)
  final List<int> children;

  PersonModel({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.parentId,
    required this.birthYear,
    required this.profilePhoto,
    required this.children,
  });
}
