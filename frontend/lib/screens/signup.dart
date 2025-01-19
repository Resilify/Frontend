import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/text_field.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formkey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void signup(context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      print(firstNameController.text);
      print(lastNameController.text);

      Navigator.pushNamedAndRemoveUntil(
        context, '/home',
        (Route<dynamic> route) => false,
        );

      print("Login Presed");
    } else {
      print("Login unsuccessful");
    }
  }

  _signin(context) {
    Navigator.pushNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(children: [
          // above section and image
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(
              child: Image.asset('assets/img/logo_2.png'),
            ),
          ),

          // all the sign up widgets
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
                      padding:
                          const EdgeInsets.only(left: 30, top: 0, right: 30),

                      // title and rest of the details in coloum format
                      child: ListView(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Sign up",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // text
                                      Text(
                                        "First Name",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTextColor,
                                        ),
                                      ),

                                      // input feild for first name
                                      CustomTextField(
                                        controller: firstNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your first name";
                                          }
                                          return null;
                                        },
                                        hintText: "Enter first name",
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),

                                      // text
                                      Text(
                                        "Last Name",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTextColor,
                                        ),
                                      ),

                                      // input feild for last name
                                      CustomTextField(
                                        controller: lastNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your last name";
                                          }
                                          return null;
                                        },
                                        hintText: "Enter last name",
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),

                                      // text
                                      Text(
                                        "Email",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTextColor,
                                        ),
                                      ),

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
                                        controller: userNameController,
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),

                                      // text
                                      Text(
                                        "Password",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTextColor,
                                        ),
                                      ),

                                      // input feild for password
                                      CustomTextField(
                                          controller: passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your password";
                                            }
                                            return null;
                                          },
                                          hintText: "Enter password",
                                          hasAsteriks: true),

                                      SizedBox(
                                        height: 15,
                                      ),

                                      // text
                                      Text(
                                        "Confirm Password",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTextColor,
                                        ),
                                      ),

                                      // input feild for confirm password
                                      CustomTextField(
                                          controller: passwordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please re-enter your password";
                                            }
                                            return null;
                                          },
                                          hintText: "Re-enter password",
                                          hasAsteriks: true),
                                    ])),

                            SizedBox(
                              height: 24,
                            ),

                            //sign up button
                            CustomButton(
                                text: "Sign Up",
                                onPress: () {
                                  signup(context);
                                }),
                            // text

                            SizedBox(
                              height: 12,
                            ),

                            Text(
                              "OR SIGN UP WITH",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryTextColor,
                                  fontSize: 12),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(
                              height: 16,
                            ),

                            //other login options
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print("goolge");
                                  },
                                  child: Image.asset(
                                    'assets/img/google.png',
                                    height: 32,
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                InkWell(
                                  onTap: () {
                                    print("facebook");
                                  },
                                  child: Image.asset(
                                    'assets/img/facebook.png',
                                    height: 32,
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('apple');
                                  },
                                  child: Image.asset(
                                    'assets/img/apple.png',
                                    height: 32,
                                  ),
                                )
                              ],
                            ),

                            // navigate to sign up
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      color: AppColors.primaryTextColor),
                                ),
                                TextButton(
                                  child: Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryTextColor),
                                  ),
                                  onPressed: () {
                                    _signin(context);
                                  },
                                ),
                              ],
                            ),
                          ]))))
        ]));
  }
}
