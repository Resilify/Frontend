// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_main.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserMainAdapter extends TypeAdapter<UserMain> {
  @override
  final int typeId = 0;

  @override
  UserMain read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserMain(
      uid: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserMain obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
