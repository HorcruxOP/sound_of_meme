import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/others/login_page.dart';
import 'package:sound_of_meme/services/functions/app_functions.dart';
import 'package:sound_of_meme/services/model/song_details_model.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:sound_of_meme/widgets/song_details_widget.dart';

class SongDetailsPage extends StatefulWidget {
  final SongDetailsModel data;
  final int? index;
  const SongDetailsPage({super.key, required this.data, this.index});

  @override
  State<SongDetailsPage> createState() => _SongDetailsPageState();
}

class _SongDetailsPageState extends State<SongDetailsPage> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = Provider.of<MemeSongProvider>(context, listen: false)
        .checkIsLiked(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.songName),
        actions: [
          IconButton(
            onPressed: () async {
              if (Provider.of<MemeSongProvider>(context, listen: false)
                  .accessToken
                  .isNotEmpty) {
                if (isLiked) {
                  await Provider.of<MemeSongProvider>(context, listen: false)
                      .dislikeSong(widget.data.songId);
                  setState(() {
                    isLiked = false;
                  });
                } else {
                  await Provider.of<MemeSongProvider>(context, listen: false)
                      .likeSong(widget.data.songId, widget.data);
                  setState(() {
                    isLiked = true;
                  });
                }
              } else {
                AppFunctions.customSnackBar(
                  context,
                  Colors.red.shade900,
                  SnackBarAction(
                    textColor: Colors.white,
                    label: "Login",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                  const Text(
                    "You need to login first!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            },
            isSelected: isLiked,
            selectedIcon: const Icon(
              CupertinoIcons.heart_fill,
            ),
            icon: const Icon(
              CupertinoIcons.heart,
            ),
          ),
        ],
      ),
      body: SongDetailsWidget(
        index: widget.index,
        data: widget.data,
      ),
    );
  }
}
