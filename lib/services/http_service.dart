import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static const String baseUrl = "https://beytullahpaytar.com.tr/api";

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
    );
  }

  static Future<http.Response> post(
      String endpoint,
      Map<String, dynamic>? body,
      ) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return http.delete(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
