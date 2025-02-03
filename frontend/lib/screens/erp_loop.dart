import 'package:flutter/foundation.dart'; // to check the platform either web/android
import 'package:flutter/material.dart'; //ui
import 'package:just_audio/just_audio.dart'; //for audio playback
import 'package:record/record.dart'; // android voice recording
import 'package:rive/rive.dart'; //animations
import 'package:path_provider/path_provider.dart'; //to store recording in android
import 'dart:io'; //to access files in android env
import 'package:microphone/microphone.dart'; // web voice recording
import 'package:permission_handler/permission_handler.dart'; //to get mic permission
import "package:pie_timer/pie_timer.dart"; //timer widget
import "package:duration_time_picker/duration_time_picker.dart"; //duration picker widget

class ERPLoopPage extends StatefulWidget {
  //stateful bc the animations and widgets change states
  const ERPLoopPage({super.key});

  @override
  _ERPLoopPageState createState() => _ERPLoopPageState();
}

class _ERPLoopPageState extends State<ERPLoopPage>
    with TickerProviderStateMixin {
  late RiveAnimationController
      _eyeBlinkController; //animation controller for mascot
  late RiveAnimationController _talkingController;
  late RiveAnimationController _micController; //mic animation controllers
  late RiveAnimationController _waveDisplayStartRecordController;
  late RiveAnimationController _listeningController;
  late RiveAnimationController _binDisplayEndRecordController;
  late RiveAnimationController _deleteRecordController;

  late MicrophoneRecorder _microphoneRecorder; //web voice recording controller
  late AudioPlayer _audioPlayer; //audio playback controller
  var record = AudioRecorder(); //android voice recording controller

  late PieAnimationController _pieAnimationController; //timer controller
  DateTime? _startTime; //start time of the timer
  Duration _elapsedTime = Duration.zero; //elapsed time of the timer
  Duration _duration = const Duration(
      hours: 0, minutes: 20); //starting time of the timer (default: 20 minutes)
  bool hasRecording = false;
  bool isTalking = false;
  bool freeze = false;
  bool _isTimerInitialized = false;

  String currentState =
      'idle'; //at the start, the state is idle for mic animation
  String? recordingPath;

  @override
  void initState() {
    super.initState();
    _eyeBlinkController =
        SimpleAnimation('blinking'); //eye blinking animation always playing
    _talkingController = SimpleAnimation('talking', autoplay: false);
    _micController = SimpleAnimation('idle');
    _waveDisplayStartRecordController =
        SimpleAnimation('start record', autoplay: false);
    _listeningController = SimpleAnimation('recording', autoplay: false);
    _binDisplayEndRecordController =
        SimpleAnimation('end record', autoplay: false);
    _deleteRecordController = SimpleAnimation('delete', autoplay: false);

    _audioPlayer = AudioPlayer(); //initialize audio player
    _microphoneRecorder = MicrophoneRecorder()
      ..init(); //initialize web voice recorder
  }

  @override
  void dispose() {
    _pieAnimationController.dispose();
    super.dispose();
  }

  _playRecording() async {
    setState(() {
      freeze = true;
    });

    if (!_isTimerInitialized) {
      //initialize timer controller
      _pieAnimationController = PieAnimationController(
        vsync: this,
      );
      _isTimerInitialized = true;
    }
    await Future.delayed(
        Duration(seconds: 1)); //delay to show the timer animation

    _startTimer(); // Start the timer animation
    while (_elapsedTime < _duration) {
      //while the set duration is met
      if (!kIsWeb) {
        //if android
        await _audioPlayer.setFilePath(recordingPath!);
      } else {
        //for web
        await _audioPlayer.setUrl(_microphoneRecorder.value.recording!.url);
      }

      _audioPlayer.setPitch(1.4); //setting pitch
      _audioPlayer.play(); //starting audio playback

      //when the set duration is met, pause the audio and stop the talking animation
      //this is checked as soon as the audio starts playing to pause incase the duration is met in the middle of playback
      Future.delayed(_duration, () {
        _audioPlayer.pause();
        _stopTalking();      
        return;
      });

      await Future.delayed(Duration(
          seconds:
              1)); //delay to skip the silence at the beginning of a typical voice recording

      _startTalking();

      await _audioPlayer.playerStateStream.firstWhere((playerState) =>
          playerState.processingState == ProcessingState.completed);

      _stopTalking();

      await Future.delayed(
          Duration(seconds: 1)); // one second gap before replay

      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
      }); //elapsed time is calculated throughout the session
    }
    
    _pauseTimer();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _pieAnimationController.startAnim?.call(); //start the pie timer animation
  }

  void _pauseTimer() {
    _pieAnimationController.stopAnim?.call(); //stop the pie timer animation
  }

  void _startRecording() async {
    setState(() {
      currentState = 'start record';
      _waveDisplayStartRecordController.isActive = true;
    }); //to change the mic animation to start record

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        currentState = 'recording';
        _listeningController.isActive = true;
      }); //to change the mic animation to recording
    });
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (!status.isGranted) {
        return; //exit if permission is not granted
      }
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/myFile.m4a';
      await record.start(const RecordConfig(), path: path);
    } else {
      _microphoneRecorder
          .start(); //for web voice recording, microphone package directly asks permmission and starts recording
    }
  }

  void _stopRecording() async {
    if (!kIsWeb) {
      recordingPath = await record.stop();
      if (recordingPath != null && File(recordingPath!).existsSync()) {
        print("Recording saved successfully at: $recordingPath");
        hasRecording = true; //setting the recording at a file path for android
      } else {
        hasRecording = false;
      }
    } else {
      _microphoneRecorder.stop(); //for web
      hasRecording = true;
    }

    setState(() {
      currentState = 'end record';
      _binDisplayEndRecordController.isActive = true;
    });
  }

  void _deleteRecording() {
    setState(() {
      currentState = 'delete';
      _deleteRecordController.isActive = true;
      hasRecording = false; //changing mic animations

      // Wait for the delete animation to complete before resetting
      Future.delayed(Duration(milliseconds: 800), () async {
        if (!kIsWeb) {
          await record.cancel();
          record.dispose();
        } else {
          _microphoneRecorder.stop();
        }

        setState(() {
          currentState = 'idle';
          _micController =
              SimpleAnimation('idle'); // re-initialize mic animation
          _microphoneRecorder = MicrophoneRecorder()
            ..init(); // re-initialize web recorder
          record = AudioRecorder(); // re-initialize android recorder
        });
        _pieAnimationController.resetAnim?.call(); //resetting timer to default
        _pauseTimer();
        _elapsedTime = Duration.zero;
      });
    });
  }

  void _handleTap() {
    //for mic animation state controlling
    if (currentState == 'idle') {
      _startRecording();
    } else if (currentState == 'recording') {
      _stopRecording();
    } else if (currentState == 'end record') {
      _deleteRecording();
    }
  }

  void _startTalking() {
    //mascot animation triggers
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
    backgroundColor: const Color.fromARGB(255, 224, 213, 236),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 70,
          child: _isTimerInitialized
              ? PieTimer(
                  pieAnimationController: _pieAnimationController,
                  key: ValueKey(_duration),
                  duration: _duration,
                  radius: 55,
                  fillColor: const Color.fromARGB(255, 186, 149, 207),
                  pieColor: const Color.fromARGB(255, 208, 184, 223),
                  borderColor: const Color.fromARGB(255, 116, 55, 165),
                  borderWidth: 3,
                  shadowColor: Colors.black,
                  shadowElevation: 10.0,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  isReverse: false,
                  enableTouchControls: false,
                  onCompleted: () => {},
                  onDismissed: () => {},
                )
              : Container(),
        ),
        // Adjust mascot size based on `freeze`
        SizedBox(
          height: freeze ? 500 : 350, // Increase mascot size when frozen
          child: RiveAnimation.asset(
            'assets/mascot_animation.riv',
            controllers: [_eyeBlinkController, _talkingController],
            onInit: (artboard) {
              artboard.addController(_eyeBlinkController);
            },
          ),
        ),
        // Hide controls when freeze == true
        Visibility(
          visible: !freeze,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      onTap: freeze ? null : _handleTap,
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
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: DurationTimePicker(
                      onChange: (value) {
                        if (!freeze) {
                          setState(() {
                            _duration = value;
                          });
                        }
                      },
                      duration: _duration,
                      circleColor: const Color.fromARGB(255, 179, 144, 206)
                          .withOpacity(0.5),
                      progressColor:
                          const Color.fromARGB(255, 116, 55, 165).withOpacity(1),
                      backgroundColor:
                          const Color.fromARGB(255, 210, 200, 214).withOpacity(0.5),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: freeze ||
                            isTalking ||
                            !hasRecording ||
                            _duration == Duration.zero
                        ? null
                        : _playRecording,
                    child: const Text('Start Looping'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Looped Time: ${_elapsedTime.inSeconds} seconds',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 99, 77, 133),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
