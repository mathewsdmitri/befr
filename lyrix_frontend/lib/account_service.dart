import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

const String url = 'http://localhost:8000/login'; // FastAPI endpoint
final storage = FlutterSecureStorage(); // Secure storage instance

Future<bool> sendLoginRequest(BuildContext context, String username, String password) async {
  print(username);
  print(password);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json", 
      },
      body: jsonEncode({
        'username': username,
        'email': "",
        'password': password,
        'bio': "",
        'access_token': "",
        'refresh_token': ""
    }),
    );
    if (response.statusCode == 200) {
      await storage.write(key: 'user_uuid', value: response.body); // Store UUID
      Navigator.pushReplacementNamed(context, "/home"); // Navigate to HomePage
      return true;
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    print("Request failed: $e");
    return false;
  }
}
