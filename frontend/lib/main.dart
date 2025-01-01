import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/screens/splash.dart';

void main() {
  runApp(Resilify());
}

class Resilify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Resilify",
      theme: ThemeData(primaryColor: AppColors.primaryColor),
      home: Splash(),
      routes: {
        '/login': (context) => LoginPage()
      }
    );
  }
}
