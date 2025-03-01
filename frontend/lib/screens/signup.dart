import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/models/UserDTO.dart';
import 'package:frontend/services/hive_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_label.dart';
import 'package:frontend/widgets/text_field.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formkey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Firebase Email/Password Signup Method

Future<void> signup(BuildContext context) async {
  if (_formkey.currentState != null && _formkey.currentState!.validate()) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailNameController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName("${firstNameController.text} ${lastNameController.text}");
        print("User signed up successfully: ${user.email}");

        // 🔹 Store First & Last Name with Firebase UID
        String uid = user.uid; // Get Firebase UID
        UserDTO userDTO = UserDTO(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
        );

        await HiveService().saveUser(uid, userDTO);
        print("User data stored in Hive with UID: $uid");

        // Navigate to Home Page
        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (e) {
      print("Signup error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}"))
      );
    }
  } else {
    print("Signup validation failed.");
  }
}


  void _signin(BuildContext context) {
    Navigator.pushNamed(context, '/signin');
  }

  Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      print("Google Sign-In canceled by user.");
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      print("Google Sign-In successful: ${userCredential.user?.email}");
      
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signed in as ${userCredential.user!.email}")),
      );

      // Navigate to Home Page
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      print("Google Sign-In failed.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed")),
      );
    }
  } catch (e) {
    print("Google Sign-In Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

/////////////////////////////////////////////////////////
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(children: [
          // 🔹 Logo
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Image.asset('assets/img/logo_2.png'),
            ),
          ),

          // 🔹 Signup Form
          Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 0, right: 30),
                      child: ListView(children: [
                        Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTextColor),
                        ),
                        SizedBox(height: 20),

                        // 🔹 Form Fields
                        Form(
                            key: _formkey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomLabel(text: "First Name"),
                                  CustomTextField(
                                    controller: firstNameController,
                                    validator: (value) => value!.isEmpty ? "Please enter your first name" : null,
                                    hintText: "Enter first name",
                                  ),
                                  SizedBox(height: 15),

                                  CustomLabel(text: "Last Name"),
                                  CustomTextField(
                                    controller: lastNameController,
                                    validator: (value) => value!.isEmpty ? "Please enter your last name" : null,
                                    hintText: "Enter last name",
                                  ),
                                  SizedBox(height: 15),

                                  CustomLabel(text: "Email"),
                                  CustomTextField(
                                    hintText: "Enter email",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return "Please enter your email";
                                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    controller: emailNameController,
                                  ),
                                  SizedBox(height: 15),

                                  CustomLabel(text: "Password"),
                                  CustomTextField(
                                    controller: passwordController,
                                    validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                                    hintText: "Enter password",
                                    hasAsteriks: true,
                                  ),
                                  SizedBox(height: 15),

                                  CustomLabel(text: "Confirm Password"),
                                  CustomTextField(
                                    controller: confirmPasswordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return "Please re-enter your password";
                                      if (value != passwordController.text) return "Passwords do not match";
                                      return null;
                                    },
                                    hintText: "Re-enter password",
                                    hasAsteriks: true,
                                  ),
                                ])),

                        SizedBox(height: 24),

                        // 🔹 Sign Up Button
                        CustomButton(text: "Sign Up", onPress: () => signup(context)),

                        SizedBox(height: 12),

                        Text(
                          "OR SIGN UP WITH",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryTextColor,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16),

                        // 🔹 Google, Facebook, Apple Sign-In Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => signInWithGoogle(context),
                              child: Image.asset('assets/img/google.png', height: 32),
                            ),
                            SizedBox(width: 24),
                            InkWell(
                              onTap: () => print("Facebook Sign-In"),
                              child: Image.asset('assets/img/facebook.png', height: 32),
                            ),
                            SizedBox(width: 24),
                            InkWell(
                              onTap: () => print('Apple Sign-In'),
                              child: Image.asset('assets/img/apple.png', height: 32),
                            )
                          ],
                        ),

                        SizedBox(height: 20),

                        // 🔹 Already have an account? Sign In
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?", style: TextStyle(color: AppColors.primaryTextColor)),
                            TextButton(
                              child: Text("SIGN IN", style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryTextColor)),
                              onPressed: () => _signin(context),
                            ),
                          ],
                        ),
                      ]))))
        ]));
  }
}
