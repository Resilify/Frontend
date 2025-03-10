// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameDataAdapter extends TypeAdapter<GameData> {
  @override
  final int typeId = 1;

  @override
  GameData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameData(
      gameId: fields[0] as String,
      timePlayed: fields[1] as DateTime,
      duration: fields[2] as int,
      points: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GameData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.timePlayed)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
