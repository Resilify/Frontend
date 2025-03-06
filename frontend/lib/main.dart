import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/screens/erp_loop.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/hive_service.dart';
import 'services/auth_service.dart';

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

  // Check platform for Firebase initialization
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: firebaseOptions);
  }

  // Initialize Hive
  await Hive.initFlutter();
  await HiveService.initHive();

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
      title: "Resilify",
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: _isLoading 
          ? Splash() 
          : StreamBuilder<User?>(
              stream: _authService.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;
                  if (user == null) {
                    // User is not logged in
                    return Landing();
                  }
                  // User is logged in
                  return Home();
                }
                // Checking auth state
                return Splash();
              },
            ),
      routes: {
        '/landing': (context) => Landing(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(),
        '/erp_loop': (context) => ERPLoopPage(),
        '/victory': (context) => Victory(),
        '/game_over': (context) => GameOver(),
        '/streak': (context) => Streak(),
        '/signin' : (context) => Signin(),
        '/signup' : (context) => Signup(),
        '/home' : (context) => Home(),
        '/erp_loop' : (context) => ERPLoopPage(),
        '/victory' : (context) => Victory(),
        '/game_over' : (context) => GameOver(),
         // Cognitive Restructuring Routes
        '/cognitive_input': (context) => CognitiveInputPage(),
        '/cognitive_reframed': (context) => CognitiveReframedPage(userInput: ""), // Providing empty input for now
        '/cognitive_mascot': (context) => CognitiveMascotPage(reframedThought: ""), // Providing empty input for now
      },
    );
  }
}