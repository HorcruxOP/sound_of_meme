import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sound_of_meme/services/model/song_details_model.dart';

class DatabaseFunctions {
  static Future<void> saveUserCredentials(
    String email,
    String password,
    String userName,
  ) async {
    try {
      Map<String, dynamic> map = {
        "email": email,
        "password": password,
        "name": userName,
        "createdSongs": [],
        "likedSongs": [],
        "purchasedSongs": [],
      };
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(email)
          .set(map);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> saveCreatedSongs(
      String email, SongDetailsModel songDetails) async {
    try {
      Map<String, dynamic> map = songDetails.toMap();
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(email)
          .update({
        "createdSongs": FieldValue.arrayUnion([map])
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> saveLikedSongs(
      String email, SongDetailsModel songDetails) async {
    try {
      Map<String, dynamic> map = songDetails.toMap();
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(email)
          .update({
        "likedSongs": FieldValue.arrayUnion([map])
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> savePurchasedSongs(
      String email, SongDetailsModel songDetails) async {
    try {
      Map<String, dynamic> map = songDetails.toMap();
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(email)
          .update({
        "purchasedSongs": FieldValue.arrayUnion([map])
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Map<String, dynamic>?> fetchUserData(String email) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection("userData")
          .doc(email)
          .get();
      return data.data();
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<void> saveOrderDetails(
      String orderId, int songId, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("orderDetails")
          .doc(orderId)
          .set({
        "orderId": orderId,
        "songId": songId,
        "userId": userId,
        "date": DateTime.now().toString(),
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
