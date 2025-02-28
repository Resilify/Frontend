import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/hive_service.dart';
import 'core/constants/app_colors.dart';
import 'screens/splash.dart';
import 'screens/landing.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/erp_loop.dart';
import 'screens/victory.dart';
import 'screens/game_over.dart';
import 'screens/cognitive_input.dart';
import 'screens/cognitive_reframed.dart';
import 'screens/cognitive_mascot.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   await HiveService.initHive();

//   runApp(const Resilify());
// }

class Resilify extends StatelessWidget {
  const Resilify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Resilify",
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/landing': (context) => Landing(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(),
        '/erp_loop': (context) => ERPLoopPage(),
        '/victory': (context) => Victory(),
        '/game_over': (context) => GameOver(),
        '/cognitive_input': (context) => CognitiveInputPage(),
        '/cognitive_reframed': (context) => CognitiveReframedPage(userInput: ""),
        '/cognitive_mascot': (context) => CognitiveMascotPage(reframedThought: ""),
      },
    );
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.initHive();

  // Insert test data and retrieve it
  HiveService hiveService = HiveService();
  await hiveService.insertTestData();
  hiveService.retrieveTestData();

  runApp(const Resilify());
}
