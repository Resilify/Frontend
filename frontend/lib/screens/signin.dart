import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/text_field.dart';

class Signin extends StatelessWidget {
  Signin({super.key});

  final _formkey = GlobalKey<FormState>();

  void signin(context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      print(userNameController.text);
      print(passwordController.text);

      // Navigator.pushReplacementNamed(context, '/dashboard',)

      print("Login Presed");
    } else {
      print("Login unsuccessful");
    }
  }

  _signup(context) {
    Navigator.pushNamed(context, '/signup');
  }

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
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
                          onPressed: () {},
                        ),
                      ],
                    ),
                    CustomButton(
                        text: "Sign in",
                        onPress: () {
                          signin(context);
                        }),

                    SizedBox(
                      height: 24,
                    ),

                    // text
                    Text(
                      "OR SIGN IN WITH",
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
                          onPressed: () {
                            _signup(context);
                          },
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
