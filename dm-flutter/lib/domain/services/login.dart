import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class ApiServiceAuth {
  static Future<bool> login(String username, String password) async {

    String? apiUrl = dotenv.env["API_URL"];

    final requestBody = {
    'username': username,
    'password': password,
    };

    var response = await http.post(Uri.parse("${apiUrl}/login"), body: jsonEncode(requestBody), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String token = data['token'];
      saveToken(token);
      return true;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<bool> logout() async {

    String? apiUrl = dotenv.env["API_URL"];

    String? token = getToken();

    var response = await http.post(Uri.parse(
        "${apiUrl}/logout"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
      }
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return true;
    } else {
      throw Exception('Failed to login');
    }
  }

  static String? getToken() {
    // Retorna o token armazenado no armazenamento local
    return window.localStorage['token'];
  }

  static void saveToken(String token) {
    // Armazena o token no armazenamento local (localStorage)
    window.localStorage['token'] = token;
  }
}