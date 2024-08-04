import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sound_of_meme/pages/others/create_music_page.dart';

class CreateMusicButton extends StatelessWidget {
  const CreateMusicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateMusicPage(),
          ),
        );
      },
      backgroundColor: Colors.green.shade800,
      label: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(CupertinoIcons.waveform_path_badge_plus),
          SizedBox(width: 10),
          Text(
            "Create",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
