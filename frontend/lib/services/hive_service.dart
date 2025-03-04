import 'package:frontend/models/UserDTO.dart';
import 'package:hive/hive.dart';
import '../models/user_main.dart';
import '../models/game_data.dart';
import '../models/sentiment_data.dart';
// import '../models/user_dto.dart';

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
    
    // Store only First & Last Name with UID
    var user = UserMain(
      uid: uid, 
      firstName: userDTO.firstName, 
      lastName: userDTO.lastName,
    );
    
    userBox.put(uid, user);
    print("✅ User stored DONE ! : FirstName>${user.firstName} LastName>${user.lastName}, UID > $uid");
  }

  /// Retrieve stored Firebase UID
  // String? getUID() {
  //   var userBox = Hive.box<UserMain>('user_main');
  //   if (userBox.isNotEmpty) {
  //     return userBox.values.first.uid; // Get first stored UID
  //   }
  //   return null;
  // }

  // /// Update user details
  // Future<void> updateUser(String userId, {String? firstName, String? lastName}) async {
  //   var box = Hive.box<UserMain>('user_main');
  //   var user = box.get(userId);

  //   if (user != null) {
  //     box.put(userId, user.copyWith(
  //       firstName: firstName ?? user.firstName,
  //       lastName: lastName ?? user.lastName,
  //     ));
  //     print("✅ User updated: $userId");
  //   } else {
  //     print("⚠️ User not found: $userId");
  //   }
  // }

  /// Update GameData
  Future<void> updateGameData(String gameId, {int? duration, int? points}) async {
    var box = Hive.box<GameData>('game_data');
    var game = box.get(gameId);

    if (game != null) {
      box.put(gameId, game.copyWith(
        duration: duration ?? game.duration,
        points: points ?? game.points,
      ));
      print("🎮 Game updated: $gameId");
    } else {
      print("⚠️ Game not found: $gameId");
    }
  }

  /// Update SentimentData
  Future<void> updateSentiment(String sentimentId, {double? score, String? prompt}) async {
    var box = Hive.box<SentimentData>('sentiment_data');
    var sentiment = box.get(sentimentId);

    if (sentiment != null) {
      box.put(sentimentId, sentiment.copyWith(
        score: score ?? sentiment.score,
        prompt: prompt ?? sentiment.prompt,
      ));
      print("😊 Sentiment updated: $sentimentId");
    } else {
      print("⚠️ Sentiment not found: $sentimentId");
    }
  }






























  /// Insert test data for debugging
//   Future<void> insertTestData() async {
//     var userBox = Hive.box<UserMain>('user_main');
//     var gameBox = Hive.box<GameData>('game_data');
//     var sentimentBox = Hive.box<SentimentData>('sentiment_data');

//     // Insert test user
//     var testUser = UserMain(uid: "test_uid_001", firstName: "John", lastName: "Doe");
//     userBox.put(testUser.uid, testUser);
    
//     // Insert test game data
//     var testGame = GameData(gameId: "game_001", timePlayed: DateTime.now(), duration: 120, points: 500);
//     gameBox.put(testGame.gameId, testGame);
    
//     // Insert test sentiment data
//     var testSentiment = SentimentData(sentimentId: "sent_001", time: DateTime.now(), score: 0.85, prompt: "Feeling great!");
//     sentimentBox.put(testSentiment.sentimentId, testSentiment);

//     print("🚀 Test data inserted successfully!");
//   }

//   /// Retrieve and print stored data
//   void retrieveTestData() {
//     var userBox = Hive.box<UserMain>('user_main');
//     var gameBox = Hive.box<GameData>('game_data');
//     var sentimentBox = Hive.box<SentimentData>('sentiment_data');

//     print("\n🔹 Stored User Data:");
//     for (var user in userBox.values) {
//       print("ID: ${user.userId}, Name: ${user.firstName} ${user.lastName}");
//     }

//     print("\n🎮 Stored Game Data:");
//     for (var game in gameBox.values) {
//       print("ID: ${game.gameId}, Time Played: ${game.timePlayed}, Duration: ${game.duration}, Points: ${game.points}");
//     }

//     print("\n😊 Stored Sentiment Data:");
//     for (var sentiment in sentimentBox.values) {
//       print("ID: ${sentiment.sentimentId}, Score: ${sentiment.score}, Prompt: ${sentiment.prompt}");
//     }
//   }
// }
}