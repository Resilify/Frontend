import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:rive/rive.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class Streak extends StatefulWidget {
  @override
  _StreakState createState() => _StreakState();
}

class _StreakState extends State<Streak> {
  late RiveAnimationController _flame;
  num _value = 1;

  @override
  void initState() {
    super.initState();
    _flame = SimpleAnimation('fiire', autoplay: true);
    _increaseStreak();
     _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    _goToHome();
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  _increaseStreak() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    setState(() {
      _value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goToHome(); // Ensure back button only navigates to home
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // center the children
            crossAxisAlignment:
                CrossAxisAlignment.center, // center horizontally
            children: [
              SizedBox(
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animations/flame.riv',
                  controllers: [_flame],
                ),
              ),
              SizedBox(height: 14),
              AnimatedFlipCounter(
                value: _value,
                textStyle: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ), 
              Text(
                'Day Streak',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor // Change color if desired
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
