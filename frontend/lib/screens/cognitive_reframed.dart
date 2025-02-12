import 'package:flutter/material.dart';


class CognitiveReframedPage extends StatelessWidget {
  final String userInput;
  CognitiveReframedPage({required this.userInput});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reframed Thought")),
      body: Center(child: Text(userInput)),
    );
  }
}