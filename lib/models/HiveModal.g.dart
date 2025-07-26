// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonModelAdapter extends TypeAdapter<PersonModel> {
  @override
  final int typeId = 0;

  @override
  PersonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonModel(
      id: fields[0] as int,
      name: fields[1] as String,
      hindiName: fields[2] as String,
      parentId: fields[3] as int,
      birthYear: fields[4] as int,
      profilePhoto: fields[5] as String,
      children: (fields[6] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PersonModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hindiName)
      ..writeByte(3)
      ..write(obj.parentId)
      ..writeByte(4)
      ..write(obj.birthYear)
      ..writeByte(5)
      ..write(obj.profilePhoto)
      ..writeByte(6)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
