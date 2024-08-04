// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/home.dart';
import 'package:sound_of_meme/services/functions/api_functions.dart';
import 'package:sound_of_meme/services/functions/app_functions.dart';
import 'package:sound_of_meme/services/functions/auth_functions.dart';
import 'package:sound_of_meme/services/functions/database_functions.dart';
import 'package:sound_of_meme/services/functions/razorpay_functions.dart';
import 'package:sound_of_meme/services/model/song_details_model.dart';
import 'package:sound_of_meme/services/providers/audio_player_provider.dart';

class MemeSongProvider with ChangeNotifier {
  String accessToken = "";
  String emailId = "";
  String name = "";
  bool isMusicCreating = false;
  bool customCreate = false;
  int currentLoadingMessageIndex = 0;

  SongDetailsModel? currentPlayingSong;

  List<SongDetailsModel> songDetails = [];
  List<SongDetailsModel> likedSongs = [];
  List<SongDetailsModel> myCreations = [];
  List<SongDetailsModel> purchasedSongs = [];

  final AuthFunctions _authFunctions = AuthFunctions();
  final ApiFunctions _apiFunctions = ApiFunctions();
  late RazorpayFunctions _razorpayFunctions;
  MemeSongProvider() {
    init();
  }

  void init() async {
    await fetchAllSongs(1);
  }

  void authFunction(
    BuildContext context, {
    String? email,
    String? password,
    String? userName,
  }) async {
    emailId = email!;
    name = userName!;
    if (userName.isEmpty) {
      accessToken = await _authFunctions.login(
        email: email,
        password: password,
      );
    } else {
      accessToken = await _authFunctions.signUp(
        email: email,
        password: password,
        userName: userName,
      );
      await DatabaseFunctions.saveUserCredentials(email, password!, userName);
    }
    await fetchData(email);
    notifyListeners();
    if (accessToken.isNotEmpty) {
      AppFunctions.navigateToHomeScreen(context);
    }
  }

  Future<void> fetchData(String email) async {
    var map = await DatabaseFunctions.fetchUserData(email);
    name = map!["name"];
    for (var element in map["likedSongs"]) {
      likedSongs.add(SongDetailsModel.fromMap(element));
    }
    for (var element in map["createdSongs"]) {
      myCreations.add(SongDetailsModel.fromMap(element));
    }
    for (var element in map["purchasedSongs"]) {
      purchasedSongs.add(SongDetailsModel.fromMap(element));
    }
  }

  Future<void> fetchAllSongs(int page) async {
    List<SongDetailsModel> newSongDetails =
        await _apiFunctions.getAllSongs(page: page);
    songDetails.addAll(newSongDetails);
    notifyListeners();
  }

  void refreshIndicator() async {
    songDetails.clear();
    fetchAllSongs(1);
    notifyListeners();
  }

  bool checkIsLiked(SongDetailsModel element) {
    if (likedSongs.contains(element)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> likeSong(int songId, SongDetailsModel songData) async {
    await _apiFunctions.likeSong(token: accessToken, songId: songId);
    likedSongs.add(songData);
    notifyListeners();
  }

  Future<void> viewSong(int songId, SongDetailsModel songData) async {
    await _apiFunctions.viewSong(token: accessToken, songId: songId);
  }

  Future<void> dislikeSong(int songId) async {
    await _apiFunctions.dislikeSong(token: accessToken, songId: songId);
    likedSongs.removeWhere((element) => element.songId == songId);
    notifyListeners();
  }

  Future<void> createSong(
    String prompt,
    BuildContext context,
  ) async {
    isMusicCreating = true;
    notifyListeners();
    var data = await _apiFunctions.createSong(
      token: accessToken,
      prompt: prompt,
    );

    isMusicCreating = false;
    currentLoadingMessageIndex = 0;

    myCreations.add(data!);
    await DatabaseFunctions.saveCreatedSongs(
      emailId,
      data,
    );
    AppFunctions.customSnackBar(
      context,
      Colors.green.shade900,
      SnackBarAction(
        textColor: Colors.white,
        label: "View Song",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        },
      ),
      const Text(
        "Song successfully created!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> createCustomSong(
    String title,
    String lyric,
    String genere,
    BuildContext context,
  ) async {
    isMusicCreating = true;
    notifyListeners();
    var data = await _apiFunctions.createCustomSong(
      token: accessToken,
      title: title,
      lyric: lyric,
      genere: genere,
    );
    isMusicCreating = false;
    currentLoadingMessageIndex = 0;
    myCreations.add(data!);
    await DatabaseFunctions.saveCreatedSongs(
      emailId,
      data,
    );
    notifyListeners();
    AppFunctions.customSnackBar(
      context,
      Colors.green.shade900,
      SnackBarAction(
        textColor: Colors.white,
        label: "View Song",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
          );
        },
      ),
      const Text(
        "Song successfully created!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<Map> getUserDetails() async {
    var response = await _apiFunctions.getUserDetails(token: accessToken);
    return response;
  }

  void loadingMessage() async {
    while (isMusicCreating && currentLoadingMessageIndex < 6) {
      await Future.delayed(const Duration(seconds: 20));

      if (isMusicCreating) {
        if (currentLoadingMessageIndex != 5) {
          currentLoadingMessageIndex++;
        }

        notifyListeners();
      }
    }
  }

  void buyFunc(SongDetailsModel songDetails, BuildContext context) async {
    _razorpayFunctions = RazorpayFunctions(
      onSuccess: (response) async {
        await DatabaseFunctions.saveOrderDetails(
          response.paymentId!,
          songDetails.songId,
          emailId,
        );
        purchasedSongs.add(songDetails);
        await DatabaseFunctions.savePurchasedSongs(emailId, songDetails);
        Fluttertoast.showToast(
          msg: "Payment Success",
          textColor: Colors.white,
          fontSize: 20,
          backgroundColor: Colors.green,
        );
        AppFunctions.navigateToHomeScreen(context);
      },
      onFailure: (response) {
        Fluttertoast.showToast(
          msg: "Payment Failed",
          textColor: Colors.white,
          fontSize: 20,
          backgroundColor: Colors.red,
        );
        AppFunctions.navigateToHomeScreen(context);
      },
    );
    _razorpayFunctions.initiatePayment(
      emailId,
      songDetails.songName,
    );
  }

  void toggleCustomCreate() {
    customCreate = !customCreate;
    notifyListeners();
  }

  void changeCurrentSong(
    SongDetailsModel songDetail,
    BuildContext context,
  ) async {
    currentPlayingSong = songDetail;
    await Provider.of<AudioPlayerProvider>(context, listen: false).stop();
    Provider.of<AudioPlayerProvider>(context, listen: false)
        .play(songDetail.songUrl);
    notifyListeners();
  }

  void logout() {
    accessToken = "";
    notifyListeners();
  }
}
