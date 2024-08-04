import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sound_of_meme/services/model/song_details_model.dart';

class ApiFunctions {
  String url = "http://143.244.131.156:8000";

  Future<List<SongDetailsModel>> getAllSongs({int page = 1}) async {
    final List<SongDetailsModel> songDetails = [];
    try {
      var response = await http.get(Uri.parse("$url/allsongs?page=$page"));
      var decodedResponse = jsonDecode(response.body);

      for (var element in decodedResponse["songs"]) {
        songDetails.add(SongDetailsModel.fromMap(element));
      }
      return songDetails;
    } catch (e) {
      log(e.toString());
    }
    return songDetails;
  }

  Future<void> likeSong({int songId = 0, String? token}) async {
    try {
      await http.post(
        Uri.parse("$url/like"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "song_id": songId,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> dislikeSong({int songId = 0, String? token}) async {
    try {
      await http.post(
        Uri.parse("$url/dislike"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "song_id": songId,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> viewSong({int songId = 0, String? token}) async {
    try {
      await http.post(
        Uri.parse("$url/view"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "song_id": songId,
        }),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<SongDetailsModel?> createSong({String? prompt, String? token}) async {
    try {
      var response = await http.post(
        Uri.parse("$url/create"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "song": prompt,
        }),
      );
      var decode = jsonDecode(response.body);
      return SongDetailsModel.fromMap(decode);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<SongDetailsModel?> createCustomSong(
      {String? title, String? lyric, String? genere, String? token}) async {
    try {
      var response = await http.post(
        Uri.parse("$url/createcustom"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "title": title,
          "lyric": lyric,
          "genere": genere,
        }),
      );
      var decode = jsonDecode(response.body);
      return SongDetailsModel.fromMap(decode);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Map> getUserDetails({String? token}) async {
    try {
      var response = await http.get(
        Uri.parse("$url/user"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      var decoded = jsonDecode(response.body);
      return decoded;
    } catch (e) {
      log(e.toString());
    }
    return {};
  }
}
