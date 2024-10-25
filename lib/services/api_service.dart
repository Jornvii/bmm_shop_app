import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://192.168.32.1:3000/api';

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // Return a structured response with status code and body
    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
}

}
