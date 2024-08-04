import 'package:flutter/material.dart';
import 'package:sound_of_meme/pages/home.dart';

class AppFunctions {
  static void navigateToHomeScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
      (route) => false,
    );
  }

  static void customSnackBar(
    BuildContext context,
    Color? backgroundColor,
    SnackBarAction? action,
    Widget content,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: backgroundColor,
        action: action,
        content: content,
      ),
    );
  }

  static void errorSnackBar(
    BuildContext context,
    String text,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red.shade800,
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
