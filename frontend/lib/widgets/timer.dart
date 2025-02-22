import 'package:flutter/material.dart';
import 'package:pie_timer/pie_timer.dart';

class PieTimerWidget extends StatelessWidget {
  final PieAnimationController pieAnimationController;
  final Duration duration;
  final VoidCallback onCompleted;
 

  const PieTimerWidget({
    Key? key,
    required this.pieAnimationController,
    required this.duration,
    required this.onCompleted,
   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 70,
      child: PieTimer(
              pieAnimationController: pieAnimationController,
              duration: duration,
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
              onCompleted: onCompleted,
            )
          
    );
  }
}
