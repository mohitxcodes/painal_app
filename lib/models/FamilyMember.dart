import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @HiveField(8)
  final DateTime? lastUpdated;

  // Transient field for global search (not persisted)
  String? collectionName;
  String? parentName;
  String? parentHindiName;

  FamilyMember({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.birthYear,
    required this.children,
    this.parentId,
    required this.profilePhoto,
    this.lastUpdated,
    this.collectionName,
    this.parentName,
    this.parentHindiName,
  });

  factory FamilyMember.fromMap(Map<String, dynamic> data) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return FamilyMember(
      id: parseInt(data['id']) ?? 0,
      name: data['name'] ?? '',
      hindiName: data['hindiName'] ?? '',
      birthYear: data['birthYear'] ?? '',
      children:
          (data['children'] is List)
              ? List<int>.from(
                (data['children'] as List)
                    .where((e) => e != null)
                    .map((e) => parseInt(e) ?? 0),
              )
              : <int>[],
      parentId: parseInt(data['parentId']),
      profilePhoto: data['profilePhoto'] ?? '',
      lastUpdated:
          data['lastUpdated'] != null
              ? (data['lastUpdated'] is DateTime
                  ? data['lastUpdated']
                  : (data['lastUpdated'] as Timestamp).toDate())
              : null,
    );
  }
}
