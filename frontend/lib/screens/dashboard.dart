import 'package:flutter/material.dart';
import 'package:frontend/widgets/dashboard_box.dart';
import 'package:frontend/screens/ThriveAndGrowMain.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context,
                    '/cognitive_input'); // navigate to restructuring page
              },
              child: DashboardBox(
                imagePath: "assets/img/dashboard1.png",
                label: "restructuring",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, '/erp_loop'); // navigate to erp loop page
              },
              child: DashboardBox(
                imagePath: "assets/img/dashboard2.png",
                label: "loop tape",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, '/ThriveAndGrow');
              },
              child: DashboardBox(
                imagePath: "assets/img/dashboard3.png",
                label: "thrive n grow",
              ),
            ),
            DashboardBox(
                imagePath: "assets/img/dashboard4.png", label: "exerciese"),
          ],
        ),
      ],
    );
  }
}
