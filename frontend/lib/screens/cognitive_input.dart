// import 'package:flutter/material.dart';
// import 'package:frontend/core/constants/app_colors.dart';
// import 'package:frontend/widgets/custom_button.dart';
// import 'package:frontend/widgets/custom_large_text_field.dart'; // Use the new large text field
// import 'package:frontend/widgets/custom_bottom_navigation.dart';
// import 'package:frontend/widgets/custom_app_bar.dart';
// import 'package:frontend/screens/cognitive_reframed.dart';

// class CognitiveInputPage extends StatefulWidget {
//   @override
//   _CognitiveInputPageState createState() => _CognitiveInputPageState();
// }

// class _CognitiveInputPageState extends State<CognitiveInputPage> {
//   final TextEditingController _thoughtController = TextEditingController();

//   void _navigateToReframedPage() {
//     if (_thoughtController.text.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               CognitiveReframedPage(userInput: _thoughtController.text),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Please enter your thought"),
//           backgroundColor: AppColors.primaryColor,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryColor,
//       appBar: CustomAppBar(), // Reusing global AppBar
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(height: 20),
//             Text(
//               "What's on your mind today?",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryTextColor,
//               ),
//             ),
//             SizedBox(height: 12),
//             CustomLargeTextField(
//               hintText: "Type your thought",
//               controller: _thoughtController,
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: CustomButton(
//                 text: "Enter",
//                 backgroundColor: AppColors.primaryColor,
//                 foregroundColor: Colors.white,
//                 onPress: _navigateToReframedPage,
//               ),
//             ),
//             SizedBox(height: 30),
//             Center(
//               child: Text(
//                 "Your mascot is here to support you!",
//                 style: TextStyle(fontSize: 16, color: AppColors.primaryTextColor),
//               ),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: Image.asset(
//                 'assets/img/mascot.png',
//                 height: 120,
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // Handle navigation
//         },
//       ), // Reusing global bottom navigation
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_large_text_field.dart';
import 'package:frontend/widgets/custom_bottom_navigation.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/screens/cognitive_reframed.dart';

class CognitiveInputPage extends StatefulWidget {
  const CognitiveInputPage({super.key});

  @override
  _CognitiveInputPageState createState() => _CognitiveInputPageState();
}

class _CognitiveInputPageState extends State<CognitiveInputPage> {
  final TextEditingController _thoughtController = TextEditingController();

  void _navigateToReframedPage() {
    if (_thoughtController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CognitiveReframedPage(userInput: _thoughtController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter your thought"),
          backgroundColor: AppColors.primaryColor,
        ),
      );
    }
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
                "What’s on your mind today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 15),

              // Thought Input Box
              CustomLargeTextField(
                hintText: "Type your thought",
                controller: _thoughtController,
              ),
              const SizedBox(height: 20),

              // Submit Button
              CustomButton(
                text: "Enter",
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                onPress: _navigateToReframedPage,
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



