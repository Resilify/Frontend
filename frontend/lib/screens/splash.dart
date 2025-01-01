import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // navigates to the splash screen after 3s of initialisation
  _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: ClipOval(
          child: Image.asset(
            'assets/img/logo.jpeg',
            height: 200,
          ),
        ),
      ),
    );
  }
}
