import "package:flutter/material.dart";
import "package:pie_timer/pie_timer.dart";

class PieWidget extends StatefulWidget {
  const PieWidget({Key? key}) : super(key: key);

  @override
  State<PieWidget> createState() => _PieWidgetState();
}

class _PieWidgetState extends State<PieWidget>
    with SingleTickerProviderStateMixin {
  late PieAnimationController _pieAnimationController;
  DateTime? _startTime; // Track the start time
  Duration _elapsedTime = Duration.zero; // Track elapsed time

  @override
  void initState() {
    super.initState();
    _pieAnimationController = PieAnimationController(vsync: this);
  }

  @override
  void dispose() {
    _pieAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _startTime = DateTime.now(); // Record the start time
    _pieAnimationController.startAnim?.call();
  }

  void _pauseTimer() {
    if (_startTime != null) {
      final currentTime = DateTime.now();
      setState(() {
        _elapsedTime += currentTime.difference(_startTime!); // Update elapsed time
        _startTime = null; // Reset start time
      });
    }
    _pieAnimationController.stopAnim?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PieTimer(
          pieAnimationController: _pieAnimationController,
          duration: const Duration(minutes: 1),
          radius: 150,
          fillColor: const Color.fromARGB(255, 186, 149, 207),
          pieColor: const Color.fromARGB(255, 221, 214, 214),
          borderColor: const Color.fromARGB(255, 182, 187, 183),
          borderWidth: 15,
          shadowColor: Colors.black,
          shadowElevation: 10.0,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          isReverse: false,
           enableTouchControls: false,
          onCompleted: () => {},
          onDismissed: () => {},
        ),
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: _pauseTimer, // Call the pause handler
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: _startTimer, // Call the start handler
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Elapsed Time: ${_elapsedTime.inSeconds} seconds',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
