// import 'package:flutter/material.dart';



// class CognitiveReframedPage extends StatelessWidget {
//   final String userInput;
//   CognitiveReframedPage({required this.userInput});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Reframed Thought")),
//       body: InputPage(),
//     ); reframedThought: userInput
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_bottom_navigation.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/screens/cognitive_mascot.dart';
import 'package:frontend/widgets/custom_large_text_field_two.dart';

class CognitiveReframedPage extends StatefulWidget {
  final String userInput;

  const CognitiveReframedPage({super.key, required this.userInput});

  @override
  State<CognitiveReframedPage> createState() => _CognitiveReframedPageState();
}

class _CognitiveReframedPageState extends State<CognitiveReframedPage> {
  late TextEditingController _thoughtController;

  @override
  void initState() {
    super.initState();
    _thoughtController = TextEditingController(text: widget.userInput);
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  void _navigateToMascotPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CognitiveMascotPage(reframedThought: widget.userInput)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Header Text
              Text(
                "Here's a Positive Reframe! ✨",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 15),

              // Thought Input Box
              CustomLargeTextFieldTwo(
                hintText: "AI Generated text",
                controller: _thoughtController,
              ),
              const SizedBox(height: 20),

              // Submit Button
              CustomButton(
                text: "Reinforce",
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                onPress: _navigateToMascotPage,
              ),
              const SizedBox(height: 30),

              // Supportive Text
              Text(
                "Your mascot is here to support you!",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 20),

              // Mascot Image
              Image.asset(
                'assets/img/mascot.png',
                height: screenWidth * 0.5,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

