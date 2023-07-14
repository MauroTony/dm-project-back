import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html';

class ApiService {
  static Future<bool> register(String name, String username, String password, String income) async {
    String? apiUrl = dotenv.env["API_URL"];
    print(apiUrl);
    final requestBody = {
      'name': name,
      'username': username,
      'password': password,
      'renda': income,
    };
    try {
      final response = await http.post(Uri.parse("http://127.0.0.1:5000/user"), body: jsonEncode(requestBody), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getUser() async {
    String? apiUrl = dotenv.env["API_URL"];
    String? token = getToken();
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:5000/user"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch user data');
    }
  }

  static String? getToken() {
    // Retorna o token armazenado no armazenamento local
    return window.localStorage['token'];
  }

}