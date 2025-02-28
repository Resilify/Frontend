// import 'package:hive/hive.dart';
// import '../models/user_main.dart';
// import '../models/game_data.dart';
// import '../models/sentiment_data.dart';

// class HiveService {
//   static Future<void> initHive() async {
//     Hive.registerAdapter(UserMainAdapter());
//     Hive.registerAdapter(GameDataAdapter());
//     Hive.registerAdapter(SentimentDataAdapter());

//     await Hive.openBox<UserMain>('user_main');
//     await Hive.openBox<GameData>('game_data');
//     await Hive.openBox<SentimentData>('sentiment_data');
//   }

//   // Update a specific user field using `copyWith`
//   Future<void> updateUser(String userId, {String? email, String? phone}) async {
//     var box = Hive.box<UserMain>('user_main');
//     var user = box.get(userId);

//     if (user != null) {
//       box.put(userId, user.copyWith(
//         email: email ?? user.email,
//         phoneNumber: phone ?? user.phoneNumber,
//       ));
//     }
//   }

//   // Update GameData
//   Future<void> updateGameData(String gameId, {int? duration, int? points}) async {
//     var box = Hive.box<GameData>('game_data');
//     var game = box.get(gameId);

//     if (game != null) {
//       box.put(gameId, game.copyWith(
//         duration: duration ?? game.duration,
//         points: points ?? game.points,
//       ));
//     }
//   }

//   // Update SentimentData
//   Future<void> updateSentiment(String sentimentId, {double? score, String? prompt}) async {
//     var box = Hive.box<SentimentData>('sentiment_data');
//     var sentiment = box.get(sentimentId);

//     if (sentiment != null) {
//       box.put(sentimentId, sentiment.copyWith(
//         score: score ?? sentiment.score,
//         prompt: prompt ?? sentiment.prompt,
//       ));
//     }
//   }
// }
import 'package:hive/hive.dart';
import '../models/user_main.dart';
import '../models/game_data.dart';
import '../models/sentiment_data.dart';

class HiveService {
  static Future<void> initHive() async {
    Hive.registerAdapter(UserMainAdapter());
    Hive.registerAdapter(GameDataAdapter());
    Hive.registerAdapter(SentimentDataAdapter());

    await Hive.openBox<UserMain>('user_main');
    await Hive.openBox<GameData>('game_data');
    await Hive.openBox<SentimentData>('sentiment_data');
  }

  // Function to insert test data
  Future<void> insertTestData() async {
    var userBox = Hive.box<UserMain>('user_main');
    var gameBox = Hive.box<GameData>('game_data');
    var sentimentBox = Hive.box<SentimentData>('sentiment_data');

    // Insert test user
    var testUser = UserMain(userId: "user_001", email: "test@example.com", phoneNumber: "1234567890");
    userBox.put(testUser.userId, testUser);
    
    // Insert test game data
    var testGame = GameData(gameId: "game_001", timePlayed: DateTime.now(), duration: 120, points: 500);
    gameBox.put(testGame.gameId, testGame);
    
    // Insert test sentiment data
    var testSentiment = SentimentData(sentimentId: "sent_001", time: DateTime.now(), score: 0.85, prompt: "Feeling good!");
    sentimentBox.put(testSentiment.sentimentId, testSentiment);

    print("Test data inserted successfully!");
  }

  // Function to retrieve and print stored data
  void retrieveTestData() {
    var userBox = Hive.box<UserMain>('user_main');
    var gameBox = Hive.box<GameData>('game_data');
    var sentimentBox = Hive.box<SentimentData>('sentiment_data');

    print("\n🔹 Stored User Data:");
    for (var user in userBox.values) {
      print("ID: ${user.userId}, Email: ${user.email}, Phone: ${user.phoneNumber}");
    }

    print("\n🎮 Stored Game Data:");
    for (var game in gameBox.values) {
      print("ID: ${game.gameId}, Time Played: ${game.timePlayed}, Duration: ${game.duration}, Points: ${game.points}");
    }

    print("\n😊 Stored Sentiment Data:");
    for (var sentiment in sentimentBox.values) {
      print("ID: ${sentiment.sentimentId}, Time: ${sentiment.time}, Score: ${sentiment.score}, Prompt: ${sentiment.prompt}");
    }
  }
}
