import 'package:hive/hive.dart';

part 'game_data.g.dart';

@HiveType(typeId: 1)
class GameData extends HiveObject {
  @HiveField(0)
  String gameId;

  @HiveField(1)
  DateTime timePlayed;

  @HiveField(2)
  int duration;

  @HiveField(3)
  int points;

  GameData({required this.gameId, required this.timePlayed, required this.duration, required this.points});

  GameData copyWith({DateTime? timePlayed, int? duration, int? points}) {
    return GameData(
      gameId: gameId,
      timePlayed: timePlayed ?? this.timePlayed,
      duration: duration ?? this.duration,
      points: points ?? this.points,
    );
  }
}
