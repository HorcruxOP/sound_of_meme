import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:sound_of_meme/widgets/custom_textfield.dart';
import 'package:sound_of_meme/widgets/need_login_button.dart';
import 'package:sound_of_meme/widgets/submit_button.dart';

class CreateMusicPage extends StatelessWidget {
  const CreateMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    var loadingMessages = [
      "Writing lyrics",
      "Adjusting equipment",
      "Recording vocals",
      "Producing music",
      "Mixing and mastering",
      "Finalizing the output",
    ];
    TextEditingController promptController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController lyricsController = TextEditingController();
    TextEditingController genereController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create your own music"),
      ),
      body: Consumer<MemeSongProvider>(
        builder: (context, value, child) {
          int currentLoadingIndex = value.currentLoadingMessageIndex;
          if (value.accessToken.isEmpty) {
            return const NeedLoginButton();
          }
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(12.0),
                children: [
                  !value.customCreate
                      ? CustomTextfield(
                          hintText: "Enter the prompt",
                          labelText: "Prompt",
                          controller: promptController,
                          enabled: !value.isMusicCreating,
                        )
                      : Column(
                          children: [
                            CustomTextfield(
                              hintText: "Enter the title",
                              labelText: "Title",
                              controller: titleController,
                              enabled: !value.isMusicCreating,
                            ),
                            CustomTextfield(
                              hintText: "Enter the lyrics",
                              labelText: "Lyrics",
                              controller: lyricsController,
                              enabled: !value.isMusicCreating,
                            ),
                            CustomTextfield(
                              hintText: "Enter the genere",
                              labelText: "Genere",
                              controller: genereController,
                              enabled: !value.isMusicCreating,
                            ),
                          ],
                        ),
                  Stack(
                    children: [
                      SubmitButton(
                        text: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome),
                            SizedBox(width: 10),
                            Text(
                              "Create",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        onPressed: !value.isMusicCreating
                            ? () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  FocusScope.of(context).unfocus();
                                });
                                if (value.customCreate) {
                                  value.createCustomSong(
                                    titleController.text.trim(),
                                    lyricsController.text.trim(),
                                    genereController.text.trim(),
                                    context,
                                  );
                                } else {
                                  value.createSong(
                                    promptController.text.trim(),
                                    context,
                                  );
                                }
                                value.loadingMessage();
                                promptController.clear();
                                titleController.clear();
                                lyricsController.clear();
                                genereController.clear();
                              }
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        top: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            value.toggleCustomCreate();
                          },
                          child: Icon(
                            value.customCreate
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (value.isMusicCreating)
                Center(
                  child: AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/images/loading.gif"),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                          color: Colors.green.shade900,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          loadingMessages[currentLoadingIndex],
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
