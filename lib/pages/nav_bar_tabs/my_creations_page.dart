import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/others/song_details_page.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:sound_of_meme/widgets/create_music_button.dart';
import 'package:sound_of_meme/widgets/discover_songs_widget.dart';
import 'package:sound_of_meme/widgets/need_login_button.dart';

class MyCreationsPage extends StatelessWidget {
  const MyCreationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Creations",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      body: Consumer<MemeSongProvider>(builder: (context, value, child) {
        if (value.accessToken.isEmpty) {
          return const NeedLoginButton();
        } else {
          if (value.myCreations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No song created",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                  CreateMusicButton(),
                ],
              ),
            );
          } else {
            return ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: size.width / (size.height / 1.3),
                  ),
                  itemCount: value.myCreations.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = value.songDetails[index];
                    return GestureDetector(
                      child: DiscoverSongsWidget(data: data),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => SongDetailsPage(
                              data: data,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
        }
      }),
    );
  }
}
