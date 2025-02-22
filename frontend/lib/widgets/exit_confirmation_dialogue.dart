import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(
    BuildContext context, VoidCallback onExit) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Exit"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onExit();
                Navigator.pushNamed(context, '/game_over');
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      ) ??
      false;
}
