import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_label.dart';
import 'package:frontend/widgets/text_field.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  // Firebase Email/Password Sign In
  Future<void> signin(BuildContext context) async {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final userCredential = await _authService.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
        );

        if (userCredential != null) {
          print("Login successful: ${userCredential.user?.email}");
          Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print("Login validation failed");
    }
  }

  // Navigate to Signup
  void _signup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  // Reset Password
  void _resetPassword(BuildContext context) {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email address first")),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reset Password"),
        content: Text("Send password reset email to ${emailController.text}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _authService.resetPassword(emailController.text.trim(), context);
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                // above section and image
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Center(
                    child: Image.asset('assets/img/logo_2.png'),
                  ),
                ),

                //rest of the screen components
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
                      padding: const EdgeInsets.only(left: 30, top: 50, right: 30),

                      // title and rest of the details in coloum format
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Sign in",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTextColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // textfields
                          Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // text
                                CustomLabel(text: "Email"),

                                // input feild for email
                                CustomTextField(
                                  hintText: "Enter email",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    } else if (!RegExp(
                                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                        .hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                // text
                                CustomLabel(text: "Password"),

                                // input feild for password
                                CustomTextField(
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your password";
                                      }
                                      return null;
                                    },
                                    hintText: "Enter password",
                                    hasAsteriks: true),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(fontWeight: FontWeight.w100),
                                ),
                                onPressed: () => _resetPassword(context),
                              ),
                            ],
                          ),
                          CustomButton(
                              text: "Sign in",
                              onPress: () => signin(context)),

                          SizedBox(
                            height: 24,
                          ),

                          // navigate to sign up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Do not have an account?",
                                style: TextStyle(color: AppColors.primaryTextColor),
                              ),
                              TextButton(
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryTextColor),
                                ),
                                onPressed: () => _signup(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}