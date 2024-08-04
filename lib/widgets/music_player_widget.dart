import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/others/song_details_page.dart';
import 'package:sound_of_meme/services/model/song_details_model.dart';
import 'package:sound_of_meme/services/providers/audio_player_provider.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 85,
        color: Colors.black,
        child: Consumer<MemeSongProvider>(builder: (context, value, child) {
          SongDetailsModel? data = value.currentPlayingSong;

          if (value.accessToken.isNotEmpty) {
            isLiked = value.checkIsLiked(data!);
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        trackHeight: 1,
                        thumbColor: Colors.green,
                        activeTrackColor: Colors.green,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 5,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 10,
                        ),
                      ),
                      child: Slider(
                        min: 0,
                        max: audioPlayerProvider.duration.inSeconds.toDouble(),
                        value:
                            audioPlayerProvider.position.inSeconds.toDouble(),
                        onChanged: (value) {
                          var position = Duration(seconds: value.toInt());
                          audioPlayerProvider.seek(position);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => SongDetailsPage(data: data),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  data!.imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: size.width / 2.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.songName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  data.userId,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (value.accessToken.isNotEmpty) {
                              if (!value.likedSongs.contains(data)) {
                                value.likeSong(data.songId, data);
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Login required",
                                textColor: Colors.white,
                                backgroundColor: Colors.red,
                                fontSize: 16,
                              );
                            }
                          },
                          iconSize: 30,
                          color: Colors.white,
                          selectedIcon: const Icon(
                            CupertinoIcons.heart_solid,
                            color: Colors.white,
                          ),
                          isSelected: isLiked,
                          icon: const Icon(
                            CupertinoIcons.heart,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (!audioPlayerProvider.isLoading) {
                              audioPlayerProvider.play(data.songUrl);
                            }
                          },
                          iconSize: 40,
                          icon: audioPlayerProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Icon(
                                  audioPlayerProvider.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
