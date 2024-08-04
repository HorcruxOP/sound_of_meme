import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthFunctions {
  final String _url = "http://143.244.131.156:8000";

  Future<String> login({String? email, String? password}) async {
    try {
      var response = await http.post(
        Uri.parse("$_url/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse["access_token"];
    } catch (e) {
       log(e.toString());
    }
    return "";
  }

  Future<String> signUp(
      {String? email, String? password, String? userName}) async {
    try {
      var response = await http.post(
        Uri.parse("$_url/signup"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": userName,
        }),
      );

      var decodedResponse = jsonDecode(response.body);
      return decodedResponse["access_token"];
    } catch (e) {
      log(e.toString());
    }
    return "";
  }
}
