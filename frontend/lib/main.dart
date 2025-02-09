import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/landing.dart';
import 'package:frontend/screens/signin.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/screens/splash.dart';
import 'package:frontend/screens/erp_loop.dart';
import 'package:frontend/screens/victory.dart';
import 'package:frontend/screens/game_over.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(Resilify());
}

class Resilify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "Resilify",
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        textTheme: GoogleFonts.interTextTheme(
           Theme.of(context).textTheme
        ),
      ),
      home: Splash(),
      routes: {
        '/landing': (context) => Landing(),
        '/signin' : (context) => Signin(),
        '/signup' : (context) => Signup(),
        '/home' : (context) => Home(),
        '/erp_loop' : (context) => ERPLoopPage(),
        '/victory' : (context) => Victory(),
        '/game_over' : (context) => GameOver()
      }
    );
  }
}