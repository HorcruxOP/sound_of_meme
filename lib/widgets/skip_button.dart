import 'package:flutter/material.dart';
import 'package:sound_of_meme/pages/home.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      },
      child: const Text(
        "Skip",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
