import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


class ERPLoopPage extends StatefulWidget {
   const ERPLoopPage({super.key});
  @override
  _ERPLoopPageState createState() => _ERPLoopPageState();
}

class _ERPLoopPageState extends State<ERPLoopPage> {
  late RiveAnimationController _eyeBlinkController; // Always active
  late RiveAnimationController _talkingController; // Controlled via buttons

  bool isTalking = false;

  @override
  void initState() {
    super.initState();
    _eyeBlinkController = SimpleAnimation('blinking'); // Animation for eye blinking
    _talkingController = SimpleAnimation('talking', autoplay: false); // Talking off initially
  }

  void _startLipSync() {
    setState(() {
      isTalking = true;
      _talkingController.isActive = true;
    });
  }

  void _stopLipSync() {
    setState(() {
      isTalking = false;
      _talkingController.isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ERP Loop Taping')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
            child: RiveAnimation.asset(
              'assets/mascot_animation.riv',
              controllers: [_eyeBlinkController, _talkingController],
              onInit: (artboard) {
                artboard.addController(_eyeBlinkController); // Eye blinking always active
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isTalking ? null : _startLipSync, // Disable button if already syncing
                child: Text('Start Looping'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: isTalking ? _stopLipSync : null, // Disable button if not syncing
                child: Text('Stop Looping'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}