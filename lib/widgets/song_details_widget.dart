import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/others/login_page.dart';
import 'package:sound_of_meme/services/functions/app_functions.dart';
import 'package:sound_of_meme/services/model/song_details_model.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongDetailsWidget extends StatelessWidget {
  const SongDetailsWidget({super.key, required this.data, this.index});
  final SongDetailsModel data;
  final int? index;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: data.imageUrl,
            height: size.height / 3.5,
            width: size.width / 2,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: MaterialButton(
                height: 50,
                color: Colors.green.shade800,
                onPressed: () {
                  if (Provider.of<MemeSongProvider>(
                    context,
                    listen: false,
                  ).accessToken.isNotEmpty) {
                    Provider.of<MemeSongProvider>(
                      context,
                      listen: false,
                    ).buyFunc(data, context);
                  } else {
                    AppFunctions.customSnackBar(
                      context,
                      Colors.red.shade800,
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
                child: const Text(
                  "Buy",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                height: 50,
                color: Colors.blue.shade800,
                onPressed: () async {
                  Provider.of<MemeSongProvider>(context, listen: false)
                      .changeCurrentSong(data, context);
                },
                child: const Text(
                  "Play",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "Created by: ${data.userId}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Created on: ${data.dateTime}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Tags: ${data.tags.toString().split("[").last.split("]").first.toUpperCase()}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.play_arrow),
            Text(
              " ${data.views}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 20),
            const Icon(CupertinoIcons.heart_solid),
            Text(
              " ${data.likes}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Lyrics:",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.lyrics,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
