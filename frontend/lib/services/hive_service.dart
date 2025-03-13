import 'package:frontend/models/UserDTO.dart';
import 'package:hive/hive.dart';
import '../models/user_main.dart';
import '../models/game_data.dart';
import '../models/sentiment_data.dart';

class HiveService {
  /// Initialize Hive and register adapters
  static Future<void> initHive() async {
    Hive.registerAdapter(UserMainAdapter());
    Hive.registerAdapter(GameDataAdapter());
    Hive.registerAdapter(SentimentDataAdapter());

    await Hive.openBox<UserMain>('user_main');
    await Hive.openBox<GameData>('game_data');
    await Hive.openBox<SentimentData>('sentiment_data');
  }

  /// Save User with Firebase UID
  Future<void> saveUser(String uid, UserDTO userDTO) async {
    var userBox = Hive.box<UserMain>('user_main');

    // Check if user already exists
    UserMain? existingUser = userBox.get(uid);

    if (existingUser != null) {
      // Update existing user
      existingUser.firstName = userDTO.firstName;
      existingUser.lastName = userDTO.lastName;
      userBox.put(uid, existingUser);
    } else {
      // Create new user
      var user = UserMain(
        uid: uid,
        firstName: userDTO.firstName,
        lastName: userDTO.lastName,
      );
      userBox.put(uid, user);
    }

    print(
        "✅ User stored: FirstName>${userDTO.firstName} LastName>${userDTO.lastName}, UID > $uid");
  }

  /// Retrieve user by UID
  UserMain? getUser(String uid) {
    var userBox = Hive.box<UserMain>('user_main');
    return userBox.get(uid);
  }

  /// Retrieve stored Firebase UID for auto-login
  String? getStoredUID() {
    var userBox = Hive.box<UserMain>('user_main');
    if (userBox.isNotEmpty) {
      return userBox.values.first.uid; // Get first stored UID
    }
    return null;
  }

  /// Update user details
  Future<void> updateUser(String userId,
      {String? firstName, String? lastName}) async {
    var box = Hive.box<UserMain>('user_main');
    var user = box.get(userId);

    if (user != null) {
      user.firstName = firstName ?? user.firstName;
      user.lastName = lastName ?? user.lastName;
      box.put(userId, user);
      print("✅ User updated: $userId");
    } else {
      print("⚠️ User not found: $userId");
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    var box = Hive.box<UserMain>('user_main');
    await box.delete(userId);
    print("🗑️ User deleted: $userId");
  }

  // Create a new game session
  Future<void> saveGameSession({
    required DateTime timePlayed,
    required int duration,
    required int points,
  }) async {
    var box = Hive.box<GameData>('game_data');

    var newSession = GameData(
      timePlayed: timePlayed,
      duration: duration,
      points: points,
    );

    await box.add(newSession); // Hive auto-generates key in add method
    print("New game session saved");
  }

  // Read all game sessions
  List<GameData> getAllGameSessions() {
    var box = Hive.box<GameData>('game_data');
    return box.values.toList();
  }

  /// Update GameData
  Future<void> updateGameData(String gameId,
      {int? duration, int? points}) async {
    var box = Hive.box<GameData>('game_data');
    var game = box.get(gameId);

    if (game != null) {
      box.put(
          gameId,
          game.copyWith(
            duration: duration ?? game.duration,
            points: points ?? game.points,
          ));
      print("🎮 Game updated: $gameId");
    } else {
      print("⚠️ Game not found: $gameId");
    }
  }

  /// Update SentimentData
  Future<void> updateSentiment(String sentimentId,
      {double? score, String? prompt}) async {
    var box = Hive.box<SentimentData>('sentiment_data');
    var sentiment = box.get(sentimentId);

    if (sentiment != null) {
      box.put(
          sentimentId,
          sentiment.copyWith(
            score: score ?? sentiment.score,
            prompt: prompt ?? sentiment.prompt,
          ));
      print("😊 Sentiment updated: $sentimentId");
    } else {
      print("⚠️ Sentiment not found: $sentimentId");
    }
  }

  /// Clear all user data (for logout)
  Future<void> clearUserData() async {
    var userBox = Hive.box<UserMain>('user_main');
    await userBox.clear();
    print("🧹 All user data cleared");
  }
}
