import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class ApiService {
  static Future<bool> login(String username, String password) async {

    String? apiUrl = dotenv.env["API_URL"];

    final requestBody = {
    'username': username,
    'password': password,
    };

    var response = await http.post(Uri.parse("${apiUrl!}/login"), body: jsonEncode(requestBody), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String token = data['token'];
      saveToken(token);
      return true;
    } else {
      throw Exception('Failed to login');
    }
  }
  static void saveToken(String token) {
    // Armazena o token no armazenamento local (localStorage)
    window.localStorage['token'] = token;
  }
}