import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final bool hasAsteriks;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.hasAsteriks = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          }
          return null;
        },
        controller: controller,
        obscureText: hasAsteriks,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.primaryColor),
            filled: true,
            fillColor: AppColors.fourthColor,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            )));
  }
}
