import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/hive_service.dart';
import 'package:frontend/models/user_main.dart';

import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_label.dart';
import 'package:frontend/widgets/text_field.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final HiveService _hiveService = HiveService();
  bool _isLoading = true;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _showRemoveButton = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    User? currentUser = _authService.currentUser;
    if (currentUser != null) {
      // Set email from Firebase
      emailController.text = currentUser.email ?? '';
      
      // Get user data from Hive
      UserMain? userData = _hiveService.getUser(currentUser.uid);
      if (userData != null) {
        firstNameController.text = userData.firstName;
        lastNameController.text = userData.lastName;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? currentUser = _authService.currentUser;
        
        if (currentUser != null) {
          // Update name in Firebase
          await currentUser.updateDisplayName(
              "${firstNameController.text} ${lastNameController.text}");

          // Update data in Hive
          await _hiveService.updateUser(
            currentUser.uid,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
          );

          // Update password if provided
          if (passwordController.text.isNotEmpty) {
            await currentUser.updatePassword(passwordController.text);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                
                // Show loading indicator
                setState(() {
                  _isLoading = true;
                });
                
                try {
                  await _authService.signOut();
                  
                  // Navigate to landing page and clear navigation stack
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/landing', 
                    (route) => false,
                  );
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error logging out: $e")),
                  );
                }
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
      _showRemoveButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  // Logout Button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      onPressed: _logout,
                      icon: Icon(
                        Icons.logout,
                        color: AppColors.tertiaryColor,
                        size: 24,
                      ),
                      label: Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.tertiaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // Profile Details Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture Section
                        GestureDetector(
                          onTap: () {
                            if (_image != null) {
                              setState(() {
                                _showRemoveButton = !_showRemoveButton;
                              });
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.fourthColor,
                                backgroundImage: _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? Icon(
                                        Icons.person_outline,
                                        size: 100,
                                        color: AppColors.primaryColor,
                                      )
                                    : null,
                              ),
                              // Camera Button
                              Positioned(
                                bottom: 0,
                                right: -8,
                                child: IconButton(
                                  onPressed: _pickImage,
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.tertiaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              // Remove Button (Visible when tapped and image exists)
                              if (_image != null && _showRemoveButton)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _removeImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        //rest of the fields
                        const SizedBox(height: 20),
                        CustomLabel(text: "First Name"),
                        CustomTextField(
                          controller: firstNameController,
                          hintText: "First Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "First name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomLabel(text: "Last Name"),
                        CustomTextField(
                          controller: lastNameController,
                          hintText: "Last Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Last name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomLabel(text: "Email"),
                        CustomTextField(
                          controller: emailController,
                          hintText: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Email cannot be changed",
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomLabel(text: "Age"),
                        CustomTextField(
                          controller: ageController,
                          hintText: "Age",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Age cannot be empty";
                            } else if (int.tryParse(value) == null) {
                              return "Enter a valid number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomLabel(text: "New Password"),
                        CustomTextField(
                          controller: passwordController,
                          hintText: "Enter new password",
                          hasAsteriks: true,
                          validator: (value) {
                            if (value != null && value.isNotEmpty && value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        //save button
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Save",
                            onPress: _saveProfile,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}