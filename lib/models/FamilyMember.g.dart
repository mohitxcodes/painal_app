// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FamilyMember.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FamilyMemberAdapter extends TypeAdapter<FamilyMember> {
  @override
  final int typeId = 1;

  @override
  FamilyMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FamilyMember(
      id: fields[0] as int,
      name: fields[1] as String,
      hindiName: fields[2] as String,
      birthYear: fields[3] as String,
      children: (fields[4] as List).cast<int>(),
      parentId: fields[5] as int?,
      profilePhoto: fields[6] as String,
      lastUpdated: fields[8] as DateTime?,
    )..childMembers = (fields[7] as List).cast<FamilyMember>();
  }

  @override
  void write(BinaryWriter writer, FamilyMember obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hindiName)
      ..writeByte(3)
      ..write(obj.birthYear)
      ..writeByte(4)
      ..write(obj.children)
      ..writeByte(5)
      ..write(obj.parentId)
      ..writeByte(6)
      ..write(obj.profilePhoto)
      ..writeByte(7)
      ..write(obj.childMembers)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
