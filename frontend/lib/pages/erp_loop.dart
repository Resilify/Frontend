import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:rive/rive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:microphone/microphone.dart';
import 'package:permission_handler/permission_handler.dart';

class ERPLoopPage extends StatefulWidget {
  const ERPLoopPage({super.key});

  @override
  _ERPLoopPageState createState() => _ERPLoopPageState();
}

class _ERPLoopPageState extends State<ERPLoopPage> {
  late RiveAnimationController _eyeBlinkController; // Always active
  late RiveAnimationController _talkingController; // Controlled via buttons
  late RiveAnimationController _micController; 
  late RiveAnimationController _waveDisplayStartRecordController;
  late RiveAnimationController _listeningController;
  late RiveAnimationController _binDisplayEndRecordController;
  late RiveAnimationController _deleteRecordController;
  
  late MicrophoneRecorder _microphoneRecorder;
  late AudioPlayer _audioPlayer;
  var record = AudioRecorder();

  bool hasRecording = false;
  bool isTalking = false;
  bool looping = false;
  bool freeze = false;

  String currentState = 'idle';
  String? recordingPath;

  @override
  void initState() {
    super.initState();
    _eyeBlinkController = SimpleAnimation('blinking'); // Animation for eye blinking
    _talkingController = SimpleAnimation('talking', autoplay: false); // Talking off initially
    _micController = SimpleAnimation('idle'); // shows the microphone icon
    _waveDisplayStartRecordController = SimpleAnimation('start record', autoplay: false); // the transition animation from mic to waves (starting recording quick animation)
    _listeningController = SimpleAnimation('recording', autoplay: false); // waves animation of listening (listening simulation)
    _binDisplayEndRecordController = SimpleAnimation('end record', autoplay: false); // transition animation from waves to bin (end record simulation)
    _deleteRecordController = SimpleAnimation('delete', autoplay: false); //transition animation from bin to mic (deleting simulation)
   
    _audioPlayer = AudioPlayer();
    _microphoneRecorder = MicrophoneRecorder()..init();
  }

  _playRecording() async {
    setState(() {
    freeze = true; // Disable the button during playback
  });
     for (int i = 0; i < 5; i++) {
    if (!kIsWeb) {
      await _audioPlayer.setFilePath(recordingPath!);
    }
    else{
      await _audioPlayer.setUrl(_microphoneRecorder.value.recording!.url);
    }
      
    _audioPlayer.play();
    _startTalking();
    

    // Wait for the playback to complete
    await _audioPlayer.playerStateStream.firstWhere(
        (playerState) => playerState.processingState == ProcessingState.completed);
    await _audioPlayer.stop(); // Ensure the player stops completely
    _stopTalking();
    freeze= true;
    await Future.delayed(Duration(seconds: 1));
  }
  setState(() {
    freeze = false;
  });

  }

  void _startRecording() async {
    setState(() {
      currentState = 'start record';
      _waveDisplayStartRecordController.isActive = true;
    });

    _microphoneRecorder.start();
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (!status.isGranted) {
        return;
      }
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/myFile.m4a';
      await record.start(const RecordConfig(), path: path);
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        currentState = 'recording';
        _listeningController.isActive = true;
      });
    });
  }

  void _stopRecording() async {
    if (!kIsWeb) {
  recordingPath = await record.stop();
  if (recordingPath != null && File(recordingPath!).existsSync()) {
    print("Recording saved successfully at: $recordingPath");
    hasRecording = true;
  } else {
    hasRecording = false;
  }
}
else{_microphoneRecorder.stop();
hasRecording = true;}

    setState(() {
      currentState = 'end record';
      _binDisplayEndRecordController.isActive = true;
    });
  }

  void _deleteRecording() {


    setState(() {
      currentState = 'delete';
      _deleteRecordController.isActive = true;
      hasRecording = false;

      // Wait for the delete animation to complete before resetting
      Future.delayed(Duration(milliseconds: 800), () async {
        _microphoneRecorder.stop();

        if (!kIsWeb) {
          await record.cancel();
          record.dispose();
        }

        setState(() {
          currentState = 'idle';
          _micController = SimpleAnimation('idle'); 
          _microphoneRecorder = MicrophoneRecorder();
          _microphoneRecorder.init(); // Re-initialize
          record = AudioRecorder();
        });
      });
    });
  }

  void _handleTap() {
    if (currentState == 'idle') {
      _startRecording();
    } else if (currentState == 'recording') {
      _stopRecording();
    } else if (currentState == 'end record') {
      _deleteRecording();
    }
  }

  void _startTalking() {
    setState(() {
      isTalking = true;
      _talkingController.isActive = true;
    });
  }

  void _stopTalking() {
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
        // Mascot Animation
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
        // Add spacing between the mascot and controls
        // Control Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gesture-Controlled Rive Animation
            SizedBox(
              height: 100,
              width: 100, // Adjust size as needed
              child: Opacity(
                opacity: freeze ? 0.5 : 1.0, // Adjust opacity based on freeze state
                child: GestureDetector(
                  onTap: freeze ? null : _handleTap, // Disable interactions when frozen
                  child: RiveAnimation.asset(
                    'assets/record_animation.riv',
                    controllers: [
                      _micController,
                      _waveDisplayStartRecordController,
                      _listeningController,
                      _binDisplayEndRecordController,
                      _deleteRecordController,
                    ],
                    onInit: (artboard) {
                      artboard.addController(_micController);
                    },
                  ),
                ),
              ),
            ),
            // Looping Button
            ElevatedButton(
              onPressed: freeze || isTalking || !hasRecording ? null : _playRecording, // Disable button under certain conditions
              child: const Text('Start Looping'),
            ),
          ],
        ),
      ],
    ),
  );
}

}
