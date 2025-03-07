import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:rive/rive.dart';


class HalfwayVictory extends StatefulWidget {
  @override
  _HalfwayVictoryState createState() => _HalfwayVictoryState();
}

class _HalfwayVictoryState extends  State<HalfwayVictory> {

late RiveAnimationController _idle; //idle animation
late RiveAnimationController _open; //content displaying
late RiveAnimationController _glare; // back glare entering 
late RiveAnimationController _shining; //shining effect animation


@override
void initState() {
    super.initState();
    _idle = SimpleAnimation('idle', autoplay: true);
    Future.delayed(Duration(seconds: 5), () {
      _idle.isActive = false;
      _open.isActive = true;
    });
    _open = SimpleAnimation('open', autoplay: false);
    _glare = SimpleAnimation('Glare Open', autoplay: true);
    _shining = SimpleAnimation('Loop', autoplay: true);
    _navigateToHome();
    
}

_navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 10000), () {});
   _goToHome();
  }
  
  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goToHome(); // Ensure back button only navigates to home
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor.withOpacity(0.7),
        body: Center(
      child: Expanded(
        child: RiveAnimation.asset(
          'assets/animations/game_halfway_badge.riv',
          controllers: [_idle, _open, _glare, _shining],
          fit: BoxFit.cover, 
        ),
      ),
    ),
      ),
    );
  }
}





