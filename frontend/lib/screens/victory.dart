import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:just_audio/just_audio.dart';

class Victory extends StatefulWidget {
  @override
  _VictoryState createState() => _VictoryState();
}

class _VictoryState extends  State<Victory> {

late RiveAnimationController _idle; //idle animation
late RiveAnimationController _open; //content displaying
late RiveAnimationController _glare; // back glare entering 
late RiveAnimationController _shining; //shining effect animation

 AudioPlayer audioPlayer = AudioPlayer();


@override
void initState() {
    super.initState();
    audioPlayer.setAsset('assets/sounds/victory.mp3');
    audioPlayer.play();
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
    audioPlayer.stop();
    Navigator.pushReplacementNamed(context, '/home');
  }
  
  void _goToHome() {
    audioPlayer.stop();
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
        body: Center(
      child: Expanded(
        child: RiveAnimation.asset(
          'assets/animations/game_achievement_badge.riv',
          controllers: [_idle, _open, _glare, _shining],
          fit: BoxFit.cover, 
        ),
      ),
    ),
      ),
    );
  }
}





