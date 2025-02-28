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
      userId: fields[0] as String,
      email: fields[1] as String,
      phoneNumber: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserMain obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phoneNumber);
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
