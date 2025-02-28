import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:just_audio/just_audio.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key});

  @override
  _GameOverState createState() => _GameOverState();
}

class _GameOverState extends  State<GameOver> {

late RiveAnimationController _rain; //idle animation


 AudioPlayer audioPlayer = AudioPlayer();


@override
void initState() {
    super.initState();
    audioPlayer.setAsset('assets/sounds/rain.mp3');
    audioPlayer.play();
    _rain = SimpleAnimation('rain', autoplay: true); 
    _navigateToHome(); 
    
}
_navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 17000), () {});
    audioPlayer.stop();
    Navigator.pushReplacementNamed(context, '/home');
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Expanded(
        child: RiveAnimation.asset(
          'assets/animations/game_over.riv',
          controllers: [_rain],
          fit: BoxFit.cover, 
        ),
      ),
    ),
  );
}




}


