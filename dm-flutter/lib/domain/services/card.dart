import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class ApiServiceCard {
  static Future<Map<String, dynamic>> getCardData() async {
    String? apiUrl = dotenv.env["API_URL"];
    String? token = getToken();
    final response = await http.get(Uri.parse("${apiUrl}/credit-card"),
        headers: {
          'Authorization': 'Bearer $token'
        }
    );
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else if(response.statusCode == 404) {
      print("Card not found");
      return {
        'card': 404
      };
    }else if (response.statusCode == 401) {
      return {
        'card': 401
      };
    } else(
        throw Exception('Failed to fetch card data')
    );
  }

  static Future<int> createCardData() async {
    String? apiUrl = dotenv.env["API_URL"];
    String? token = getToken();
    final response = await http.post(Uri.parse("${apiUrl}/credit-card"),
        headers: {
          'Authorization': 'Bearer $token'
        }
    );
    if (response.statusCode == 201) {
      return 201;
    } else if(response.statusCode == 400) {
      print("Card already exist");
      return 400;
    } else if (response.statusCode == 401) {
      return 401;
    } else
     (
        throw Exception('Failed to fetch card data')
    );
  }

  static Future<int> deleteCard() async {
    String? apiUrl = dotenv.env["API_URL"];
    String? token = getToken();
    final response = await http.delete(Uri.parse("${apiUrl}/credit-card"),
        headers: {
          'Authorization': 'Bearer $token'
        }
    );
    if (response.statusCode == 200) {
      return 200;
    } else if(response.statusCode == 400) {
      return 400;
    } else if (response.statusCode == 401) {
      return 401;
    } else if (response.statusCode == 404) {
      return 404;
    }else
      (
          throw Exception('Failed to fetch card data')
      );
  }

  static String? getToken() {
    // Retorna o token armazenado no armazenamento local
    return window.localStorage['token'];
  }
}