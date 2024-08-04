import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/others/song_details_page.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:sound_of_meme/widgets/create_music_button.dart';
import 'package:sound_of_meme/widgets/discover_songs_widget.dart';
import 'package:sound_of_meme/widgets/music_player_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    // if (Provider.of<MemeSongProvider>(context, listen: false)
    //         .songDetails
    //         .isEmpty &&
    //     isInitial) {
    //   Provider.of<MemeSongProvider>(context, listen: false).fetchAllSongs(1);
    //   isInitial = false;
    // }
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      Provider.of<MemeSongProvider>(context, listen: false)
          .fetchAllSongs(++page);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.green.shade900,
        title: const Text(
          "Discover",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      body: Consumer<MemeSongProvider>(
        builder: (context, value, child) {
          if (value.songDetails.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                page = 1;
                value.refreshIndicator();
              },
              child: ListView(
                controller: controller,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: size.width / (size.height / 1.3),
                    ),
                    itemCount: value.songDetails.length,
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
                                index: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: const CreateMusicButton(),
      bottomNavigationBar:
          Provider.of<MemeSongProvider>(context).currentPlayingSong == null
              ? SizedBox()
              : MusicPlayerWidget(),
    );
  }
}
