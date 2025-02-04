import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Victory extends StatefulWidget {
  @override
  _VictoryState createState() => _VictoryState();
}

class _VictoryState extends  State<Victory> {

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
    
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Expanded(
        child: RiveAnimation.asset(
          'assets/game_achievement_badge.riv',
          controllers: [_idle, _open, _glare, _shining],
          fit: BoxFit.cover, 
        ),
      ),
    ),
  );
}




}


