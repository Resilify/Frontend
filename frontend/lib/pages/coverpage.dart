import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'dart:async';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  @override
  void initState() {
    super.initState();
    // Redirect to Login Page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4B8F2),
      body: Center(
        child: ClipOval(
          child: Image.asset(
            'assets/logo.jpeg', // Path to your image
            width: 150, // Adjust the width
            height: 150,
            fit: BoxFit.cover,// Adjust the height
          ),
        ),
      ),
    );
  }
}
