import 'package:flutter/material.dart';
import 'package:frontend/widgets/dashboard_box.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            DashboardBox(
                imagePath: "assets/img/dashboard1.png", label: "resturcturing"),
            DashboardBox(
                imagePath: "assets/img/dashboard2.png", label: "loop tape"),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            DashboardBox(
                imagePath: "assets/img/dashboard3.png", label: "thrive & grow"),
            DashboardBox(
                imagePath: "assets/img/dashboard4.png", label: "exerciese"),
          ],
        ),
      ],
    );
  }
} 




