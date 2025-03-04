import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_label.dart';
import 'package:frontend/widgets/text_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Firebase Email/Password Signup Method
  Future<void> signup(BuildContext context) async {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final userCredential = await _authService.signUpWithEmailAndPassword(
          email: emailNameController.text.trim(),
          password: passwordController.text.trim(),
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          context: context,
        );

        if (userCredential != null) {
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
      print("Signup validation failed.");
    }
  }

  // Navigate to Sign In
  void _signin(BuildContext context) {
    Navigator.pushNamed(context, '/signin');
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(children: [
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
                                          validator: (value) {
                                            if (value == null || value.isEmpty) return "Please enter your password";
                                            if (value.length < 6) return "Password must be at least 6 characters";
                                            return null;
                                          },
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

                              SizedBox(height: 30),

                              // 🔹 Sign Up Button
                              CustomButton(text: "Sign Up", onPress: () => signup(context)),

                              SizedBox(height: 30),

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