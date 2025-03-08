import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

Future<bool> showExitConfirmationDialog(
    BuildContext context, String exitRoute, VoidCallback onExit) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
                      "Confirm Exit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
              ),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onExit();
                Navigator.pushReplacementNamed(context, exitRoute);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      ) ??
      false;
}
