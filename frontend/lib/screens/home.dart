import 'package:flutter/material.dart';
import 'package:frontend/screens/dashboard.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/widgets/custom_bottom_navigation.dart';
import 'package:frontend/screens/erp_loop.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int myIndex = 0;
  List<Widget> screenList = const [
    Dashboard(),
    Text("screen2"),
    Text("screen3"),
    Text("screen4"),
    ERPLoopPage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child:  screenList[myIndex],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
      ),
    );
  }
}
