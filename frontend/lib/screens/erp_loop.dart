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

class _ERPLoopPageState extends State<ERPLoopPage> with TickerProviderStateMixin {

  late RiveAnimationController _eyeBlinkController; //animation controller for mascot
  late RiveAnimationController _talkingController;
  late RiveAnimationController _micController; //mic animation controllers
  late RiveAnimationController _waveDisplayStartRecordController;
  late RiveAnimationController _listeningController;
  late RiveAnimationController _binDisplayEndRecordController;
  late RiveAnimationController _deleteRecordController;
  bool isTalking = false;

  String currentState ='idle'; //at the start, the state is idle for mic animation

  late MicrophoneRecorder _microphoneRecorder; //web voice recording controller
  late AudioPlayer _audioPlayer; //audio playback controller
  var record = AudioRecorder(); //android voice recording controller
  bool hasRecording = false;
  String? recordingPath;

  late PieAnimationController _pieAnimationController; //timer controller
  DateTime? _startTime; //start time of the timer
  Duration _elapsedTime = Duration.zero; //elapsed time of the timer
  Duration _duration = const Duration(hours: 0, minutes: 20); //starting time of the timer (default: 20 minutes)
  bool _isTimerInitialized = false;
  bool hide = false;
  

  @override
  void initState() {
    super.initState();
    _eyeBlinkController = SimpleAnimation('blinking'); //eye blinking animation always playing
    _talkingController = SimpleAnimation('talking', autoplay: false);

    _micController = SimpleAnimation('idle');
    _waveDisplayStartRecordController = SimpleAnimation('start record', autoplay: false);
    _listeningController = SimpleAnimation('recording', autoplay: false);
    _binDisplayEndRecordController = SimpleAnimation('end record', autoplay: false);
    _deleteRecordController = SimpleAnimation('delete', autoplay: false);

    _audioPlayer = AudioPlayer(); //initialize audio player
    _microphoneRecorder = MicrophoneRecorder()..init(); //initialize web voice recorder
  }

  @override
  void dispose() {
    _pieAnimationController.dispose();
    super.dispose();
  }

  _playRecording() async {
    setState(() {
      hide = true;
    });

    if (!_isTimerInitialized) {
      //initialize timer controller
      _pieAnimationController = PieAnimationController(
        vsync: this,
      );
      _isTimerInitialized = true;
    }
    await Future.delayed(
        Duration(seconds: 1)); //delay to show the timer animation appear

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

      _audioPlayer.setPitch(1.4); //setting pitch (works only on android)
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
          playerState.processingState == ProcessingState.completed); //waiting for the audioplayer to complete one cycle

      _stopTalking();

      await Future.delayed(
          Duration(seconds: 1)); // one second gap before replay

      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
      }); //elapsed time is calculated after each cycle
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
    }); //transition animation from mic to recording waves

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        currentState = 'recording';
        _listeningController.isActive = true;
      }); //animation of recording waves
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
      _microphoneRecorder.start(); //for web voice recording, permmission asked directly by package
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
      _microphoneRecorder.stop(); //for web it automatically saves the recording in a blob url
      hasRecording = true;
    }

    setState(() {
      currentState = 'end record';
      _binDisplayEndRecordController.isActive = true; //transition animation from recording waves to bin
    });
  }

  void _deleteRecording() {
    setState(() {
      currentState = 'delete';
      _deleteRecordController.isActive = true; // transition animation from bin to mic (idle)
      hasRecording = false; 

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
          _micController = SimpleAnimation('idle'); // re-initialize mic animation as this rive animation follows a sequence in a state machine
          _microphoneRecorder = MicrophoneRecorder()..init(); // re-initialize web recorder after calling stop function
          record = AudioRecorder(); // re-initialize android recorder after calling dispose
        });
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
    body: Column( //main column
      mainAxisAlignment: MainAxisAlignment.center, // is centered
      children: [ //that centered main column has children
        SizedBox( //timer widget only renderes if the timer is initialized
          height: 40,
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
                  onCompleted: () => {Navigator.pushNamed(context, '/victory')},
                  onDismissed: () => {},
                )
              : Container(), //else an empty container
        ),
        // Adjust mascot size based on `hide`
        SizedBox(
          height: hide ? 450 : 350, // Increase mascot size when when inputs and commands are hidden and loop starts
          child: RiveAnimation.asset(
            'assets/animations/mascot_animation.riv',
            controllers: [_eyeBlinkController, _talkingController],
            onInit: (artboard) {
              artboard.addController(_eyeBlinkController);
            },
          ),
        ),
        // Hide controls when hide == true
        Visibility(
          visible: !hide, //visible when it's not hidden
          child: Column( // a column for the controls
            children: [ //that column has children
              Row( //which are in a row
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      onTap: hide ? null : _handleTap,
                      child: RiveAnimation.asset(
                        'assets/animations/record_animation.riv',
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
                        if (!hide) {
                          setState(() {
                            _duration = value;
                          });
                        }
                      },
                      duration: _duration, //the picked value is set in the middle of the picker
                      circleColor: const Color.fromARGB(255, 179, 144, 206).withOpacity(0.5),
                      progressColor:const Color.fromARGB(255, 57, 17, 132).withOpacity(1),
                      backgroundColor:const Color.fromARGB(255, 210, 200, 214).withOpacity(0.5),
                    ),
                  ),
                  SizedBox( //whitespace
                height: 20,
                width: 20,
              ),
                  ElevatedButton(
                    onPressed: hide || !hasRecording || _duration == Duration.zero //button is disabled when the loop is running, no recording is available or duration picked is zero
                    ? null : _playRecording, //or else the loop begins ( when both duration and voice input are available)
                    child: const Text('Loop!'),
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
