import 'package:flutter/foundation.dart'; // this package is to check the platform either web/android
import 'package:flutter/material.dart'; //ui
import 'package:just_audio/just_audio.dart'; //playback purpose
import 'package:record/record.dart'; //android voice recording
import 'package:rive/rive.dart'; //animations with rive
import 'package:path_provider/path_provider.dart'; //to store recording files in android
import 'dart:io'; //to access files
import 'package:microphone/microphone.dart'; //to record in web
import 'package:permission_handler/permission_handler.dart'; //to get mic permission
import "package:pie_timer/pie_timer.dart";
import "package:duration_time_picker/duration_time_picker.dart";

class ERPLoopPage extends StatefulWidget {
  //stateful widget because the animations change
  const ERPLoopPage({super.key});

  @override
  _ERPLoopPageState createState() => _ERPLoopPageState();
}

class _ERPLoopPageState extends State<ERPLoopPage>
    with TickerProviderStateMixin {
  late RiveAnimationController _eyeBlinkController;
  late RiveAnimationController _talkingController;
  late RiveAnimationController _micController;
  late RiveAnimationController _waveDisplayStartRecordController;
  late RiveAnimationController _listeningController;
  late RiveAnimationController _binDisplayEndRecordController;
  late RiveAnimationController _deleteRecordController;

  late MicrophoneRecorder _microphoneRecorder; //for web
  late AudioPlayer
      _audioPlayer; //for both web and android (plays from url and filepath)
  var record = AudioRecorder(); //for android

  late PieAnimationController _pieAnimationController;
  DateTime? _startTime; // Track the start time
  Duration _elapsedTime = Duration.zero; // Track elapsed time
  Duration _duration = const Duration(hours: 0, minutes: 0);
  bool hasRecording = false;
  bool isTalking = false;
  bool freeze = false;

  String currentState = 'idle'; //at the beginning mic is shown
  String? recordingPath;

  @override
  void initState() {
    super.initState();
    _eyeBlinkController =
        SimpleAnimation('blinking'); // eye blinking animation always playing
    _talkingController = SimpleAnimation('talking',
        autoplay: false); //talking animation off initially
    _micController = SimpleAnimation('idle'); // shows the microphone icon
    _waveDisplayStartRecordController = SimpleAnimation('start record',
        autoplay: false); // the transition animation from mic to waves
    _listeningController = SimpleAnimation('recording',
        autoplay: false); // waves animation of listening (listening simulation)
    _binDisplayEndRecordController = SimpleAnimation('end record',
        autoplay:
            false); // transition animation from waves to bin (end record simulation)
    _deleteRecordController = SimpleAnimation('delete',
        autoplay:
            false); //transition animation from bin to mic (deleting simulation)

    _audioPlayer = AudioPlayer();
    _microphoneRecorder = MicrophoneRecorder()..init();

    _pieAnimationController = PieAnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pieAnimationController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  _playRecording() async {
    setState(() {
      freeze = true; // disable the button during playback
    });
    _startTimer();
    for (int i = 0; i < 5; i++) {
      if (!kIsWeb) {
        // not web (android)
        await _audioPlayer.setFilePath(recordingPath!);
      } else {
        //for web
        await _audioPlayer.setUrl(_microphoneRecorder.value.recording!.url);
      }
      _audioPlayer.setPitch(1.4);
      _audioPlayer.play();
      await Future.delayed(Duration(
          seconds: 1)); // delaying a bit before the animation is played
      _startTalking();

      // wait for the playback to complete
      await _audioPlayer.playerStateStream.firstWhere((playerState) =>
          playerState.processingState == ProcessingState.completed);
      await _audioPlayer.stop(); // ensure the player stops completely
      _stopTalking();
      freeze = true;
      await Future.delayed(
          Duration(seconds: 1)); //delaying a second after each loop
    }
    setState(() {
      freeze = false; // re-enabling the buttons after the loop ends
    });
    _pauseTimer();
  }

  void _startTimer() {
    _startTime = DateTime.now(); // Record the start time
    _pieAnimationController.startAnim?.call();
  }

  void _pauseTimer() {
    if (_startTime != null) {
      final currentTime = DateTime.now();
      setState(() {
        _elapsedTime +=
            currentTime.difference(_startTime!); // Update elapsed time
        _startTime = null; // Reset start time
      });
    }
    _pieAnimationController.stopAnim?.call();
  }

  void _startRecording() async {
    setState(() {
      currentState = 'start record';
      _waveDisplayStartRecordController.isActive = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      // a little delay to make sure the animation completes
      setState(() {
        currentState = 'recording';
        _listeningController.isActive = true;
      });
    });
    if (!kIsWeb) {
      var status = await Permission.microphone
          .request(); //for android permisssion to use the mic is asked
      if (!status.isGranted) {
        return;
      }
      final directory =
          await getApplicationDocumentsDirectory(); //accessing the directory
      final path =
          '${directory.path}/myFile.m4a'; //geting a path to store the recording (m4a format)
      await record.start(const RecordConfig(), path: path);
    } else {
      _microphoneRecorder
          .start(); //for web the package takes care of asking for permission automatically
    }
  }

  void _stopRecording() async {
    if (!kIsWeb) {
      recordingPath = await record.stop();
      if (recordingPath != null && File(recordingPath!).existsSync()) {
        //making sure the recording is set to the path in android
        print("Recording saved successfully at: $recordingPath");
        hasRecording = true;
      } else {
        hasRecording = false;
      }
    } else {
      _microphoneRecorder.stop();
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
          _micController =
              SimpleAnimation('idle'); // re-initialize mic animation
          _microphoneRecorder = MicrophoneRecorder()
            ..init(); // re-initialize web recorder
          record = AudioRecorder(); // re-initialize android recorder
        });
        _pieAnimationController.resetAnim?.call();
        _pauseTimer();
        _elapsedTime = Duration.zero;
      });
    });
  }

  void _handleTap() {
    //chaning the rive animation and functions based on state and gesture
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
      backgroundColor: const Color.fromARGB(255, 224, 213, 236),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60, // Adjust the height to make it smaller or larger
            width: 70, // Adjust the width to make it smaller or larger
            child: PieTimer(
              pieAnimationController: _pieAnimationController,
              duration: const Duration(minutes: 1),
              radius: 55, // Adjust radius for the size of the pie
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
            ),
          ),
          // Mascot Animation
          SizedBox(
            height: 350,
            child: RiveAnimation.asset(
              'assets/mascot_animation.riv',
              controllers: [_eyeBlinkController, _talkingController],
              onInit: (artboard) {
                artboard.addController(
                    _eyeBlinkController); // eye blinking always active
              },
            ),
          ),
          // Control Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // gesture controlled rive animation
              SizedBox(
                height: 100,
                width: 100,
                child: Opacity(
                  opacity: freeze ? 0.5 : 1.0, // opacity based on freeze state
                  child: GestureDetector(
                    onTap: freeze
                        ? null
                        : _handleTap, // disable interactions when frozen
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
              // Duration Picker
              SizedBox(
                  height: 150,
                  width: 150,
                  child: DurationTimePicker(
                    onChange: (value) {
                      _duration = value;
                      print(_duration);
                      setState(() {});
                    },
                    duration: _duration,
                    circleColor: const Color.fromARGB(255, 179, 144, 206)
                        .withOpacity(0.5),
                    progressColor:
                        const Color.fromARGB(255, 116, 55, 165).withOpacity(1),
                    backgroundColor: const Color.fromARGB(255, 210, 200, 214)
                        .withOpacity(0.5),
                  )),
              // Looping Button
              ElevatedButton(
                onPressed: freeze || isTalking || !hasRecording
                    ? null
                    : _playRecording, // disable button under these conditions
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
                  color: Color.fromARGB(255, 99, 77, 133), // Red color
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
