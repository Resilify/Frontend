import 'package:flutter/foundation.dart'; // to check the platform either web/android
import 'package:flutter/material.dart'; //ui
import 'package:frontend/core/constants/app_colors.dart';
import 'package:just_audio/just_audio.dart'; //for audio playback
import 'package:record/record.dart'; // android voice recording
import 'package:rive/rive.dart'; //animations
import 'package:path_provider/path_provider.dart'; //to store recording in android
import 'dart:io'; //to access files in android env
import 'package:microphone/microphone.dart'; // web voice recording
import 'package:permission_handler/permission_handler.dart'; //to get mic permission
import "package:pie_timer/pie_timer.dart"; //timer widget
import "package:frontend/widgets/duration_picker.dart";
import "package:frontend/widgets/exit_confirmation_dialogue.dart";
import "package:frontend/widgets/timer.dart"; //customised timer widget
import "package:frontend/widgets/microphone.dart"; //customised mic widget
import "package:frontend/widgets/mascot.dart";

class ERPLoopPage extends StatefulWidget {//stateful bc the animations and widgets change states
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
  DateTime? _pauseStartTime;
  Duration _pauseDuration = Duration.zero;
  Duration _duration = const Duration(hours: 0, minutes: 20); //default start time of the timer
  bool _isTimerInitialized = false;
  bool gameStarted = false; //game state

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
      _microphoneRecorder
          .start(); //for web voice recording, permmission asked directly by package
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
        } 
        else {
          _microphoneRecorder.stop();
        }
        setState(() {
          currentState = 'idle';
          _micController = SimpleAnimation('idle'); // re-initialize mic animation 
          _microphoneRecorder = MicrophoneRecorder()..init(); // re-initialize web recorder after calling stop function
          record = AudioRecorder(); // re-initialize android recorder after calling dispose
        });
      });
    });
  }

  _startGame() async {
    setState(() {
      gameStarted = true; //game starts
    });
    if (!_isTimerInitialized) {//initialize timer controller
      _pieAnimationController = PieAnimationController(
        vsync: this,
      );
      _isTimerInitialized = true;
    }
    await Future.delayed(Duration(seconds: 1)); //delay to show the timer animation appear
    _startTimer(); // Start the timer animation
    while (_elapsedTime < _duration) {  //while the set duration is met
      if (!kIsWeb) {  //if android
        await _audioPlayer.setFilePath(recordingPath!);
      } 
      else {//for web
        await _audioPlayer.setUrl(_microphoneRecorder.value.recording!.url);
      }
      _audioPlayer.setPitch(1.4); //setting pitch (works only on android)
      _audioPlayer.play(); //starting audio playback
      await Future.delayed(Duration(milliseconds:500)); // minor delay for the animation to start playing
      _startTalking();
      await _audioPlayer.playerStateStream.firstWhere((playerState) =>
          playerState.processingState == ProcessingState.completed); //waiting for the audioplayer to complete one cycle
      _stopTalking();

    }
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _pieAnimationController.startAnim?.call(); //start the pie timer animation
  }

  void _pauseTimer() {
    _pieAnimationController.stopAnim?.call(); //stop the pie timer animation
  }

  void _startTalking() {//mascot animation triggers
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

  void _pauseGame(){ //pause game when back button is pressed and confimation box is shown
     _pauseTimer();
     _audioPlayer.pause();
     _pauseStartTime = DateTime.now(); //starting a pause timer incase user resumes back to game
    _elapsedTime = DateTime.now().difference(_startTime!); //recording the elapsed time if user exits the game
  }

  void _resumeGame(){
    _pauseDuration += DateTime.now().difference(_pauseStartTime!); //calculating the pause duration if user resumes
    setState(() {
      _elapsedTime = DateTime.now().difference(_startTime!) - _pauseDuration; //updating elapsed time deducting pause time
    });
    print(_elapsedTime);
    _pieAnimationController.startAnim?.call(); //resuming timer
    _audioPlayer.play(); //resuming audio player
  }

   void _handleTap() {//for mic animation state controlling
    if (currentState == 'idle') {
      _startRecording();
    } else if (currentState == 'recording') {
      _stopRecording();
    } else if (currentState == 'end record') {
      _deleteRecording();
    }
  }
  
  @override
  Widget build(BuildContext context) {
     final double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (gameStarted) {//if game has started
          _pauseGame();
          bool shouldPop = await showExitConfirmationDialog(context, () {}); // show confirmation widget
          if (!shouldPop) { //if user selectes cancel in the dialogue
            _resumeGame(); // Resume from where it left off
          }
          return shouldPop;
        }
        return true; // allow to go back directly if game has not started
      },
      child: Scaffold(
        appBar: AppBar(title: Text('ERP Loop Taping')),
        backgroundColor: const Color.fromARGB(255, 224, 213, 236),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: _isTimerInitialized
                  ? PieTimerWidget(
                      pieAnimationController: _pieAnimationController,
                      duration: _duration,
                      onCompleted: () => {
                            _audioPlayer.pause(),
                            _stopTalking(),
                            Navigator.pushNamed(context, '/victory'),
                          },
                    )
                  : Text(
                      "Tap on the mic and speak what's on your mind!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
              ),
            ),
            MascotWidget(gameStarted: gameStarted, controllers: [_eyeBlinkController, _talkingController]),
            Visibility(
              visible: !gameStarted,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MicrophoneWidget(
                        onTap: _handleTap,
                        controllers: [ _micController, _waveDisplayStartRecordController, _listeningController, _binDisplayEndRecordController, _deleteRecordController],
                      ),
                      DurationPickerWidget(
                        duration: _duration,
                        onDurationChange: (value) {
                          setState(() {
                            _duration = value;
                          });
                        },
                      ),
                      SizedBox(height: 20, width: 20),
                      ElevatedButton(
                        onPressed: !hasRecording || _duration == Duration.zero? null: _startGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color.fromARGB(255, 100, 62, 172).withOpacity(1), 
                          foregroundColor: Colors.white, ),
                        child: const Text('Loop!'),
                      )
                    ],
                  ),
                ],),
            ),
          ],),
      ),
    );
  }
}