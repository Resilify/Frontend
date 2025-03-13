import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/screens/erp_loop.dart';
import 'package:frontend/screens/halfway_victory.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/landing.dart';
import 'package:frontend/screens/signin.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/screens/splash.dart';
import 'package:frontend/screens/streak.dart';
import 'package:frontend/screens/victory.dart';
import 'package:frontend/screens/game_over.dart';
import 'package:frontend/screens/cognitive_input.dart';
import 'package:frontend/screens/cognitive_reframed.dart';
import 'package:frontend/screens/cognitive_mascot.dart';
import 'package:frontend/screens/ThriveAndGrowMain.dart';
import 'package:frontend/screens/MythBusting.dart';
import 'package:frontend/screens/MotivationalVideos.dart';
import 'package:frontend/screens/SuccessStories.dart';
import 'package:frontend/screens/SelfCareReward.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/hive_service.dart';
import 'services/auth_service.dart';
import 'package:frontend/screens/breathing.dart';

//save keys where safe ** k3
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCDCca1HTVvJVLdOEezQF4syob8FBsleaQ",
  authDomain: "resilify-flaskbe.firebaseapp.com",
  databaseURL: "https://resilify-flaskbe-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "resilify-flaskbe",
  storageBucket: "resilify-flaskbe.firebasestorage.app",
  messagingSenderId: "176944736107",
  appId: "1:176944736107:web:fd761d6f5a51f18ab70e2e",
  measurementId: "G-NBN3LV4JC8",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: firebaseOptions);
      print("Firebase Initialized Successfully.");
    } else {
      print("Firebase was already initialized.");
    }
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }

  // Initialize Hive safely
  try {
    await Hive.initFlutter();
    await HiveService.initHive();
    print("Hive Initialized Successfully.");
  } catch (e) {
    print("Hive Initialization Error: $e");
  }

  runApp(const Resilify());
}

class Resilify extends StatefulWidget {
  const Resilify({super.key});

  @override
  State<Resilify> createState() => _ResilifyState();
}

class _ResilifyState extends State<Resilify> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    // Simulates splash screen timing while checking auth state
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: "Resilify",
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: _isLoading 
          ? const Splash() 
          : StreamBuilder<User?>(
              stream: _authService.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;
                  if (user == null) {
                    // User is not logged in
                    return const Landing();
                  }
                  // User is logged in
                  return const Home();
                }
                // Checking auth state
                return const Splash();
              },
            ),
      routes: {
        '/landing': (context) => const Landing(),
        '/signin': (context) => const Signin(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const Home(),
        '/erp_loop': (context) => const ERPLoopPage(),
        '/victory': (context) => const Victory(),
        '/game_over': (context) => const GameOver(),
        '/streak': (context) => Streak(),  // Removed const if constructor isn't const
        '/halfway_victory': (context) => HalfwayVictory(),  // Removed const if constructor isn't const
        // Cognitive Restructuring Routes
        '/cognitive_input': (context) => const CognitiveInputPage(),
        '/cognitive_reframed': (context) => const CognitiveReframedPage(userInput: ""), 
        '/cognitive_mascot': (context) => const CognitiveMascotPage(reframedThought: ""),
        '/ThriveAndGrow': (context) => const ThriveAndGrow(),
        '/MythBusting': (context) => const MythBusting(),
        '/MotivationalVideos': (context) => const MotivationalVideos(),
        '/SuccessStories': (context) => const SuccessStories(),
        '/SelfCareReward': (context) => const SelfCareReward(),
        '/breathing_exercise': (context) => const Breathing(),
      },
    );
  }
}