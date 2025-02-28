import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

final storage = FlutterSecureStorage(); // Secure storage instance

Future<bool> sendLoginRequest(BuildContext context, String username, String password) async {
  const String url = 'http://localhost:8000/login'; // FastAPI endpoint
  String username_test = "";
  String email_test = "";
  if (username.contains('@')){
    email_test = username;
  }else{
    username_test = username;
  }
  print(username);
  print(password);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json", 
      },
      body: jsonEncode({
        'username': username_test,
        'email': email_test,
        'password': password,
        'bio': "",
        'access_token': "",
        'refresh_token': ""
    }),
    );
    if (response.statusCode == 200) {
      await storage.write(key: 'user_uuid', value: response.body); // Store UUID
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

Future<bool> sendForgotPassword(BuildContext context, String username) async {
  const String url = 'http://localhost:8000/forgot_password'; // FastAPI endpoint
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json", 
      },
      body: jsonEncode({
        'username': "",
        'email': username,
        'password': "",
        'bio': "",
        'access_token': "",
        'refresh_token': ""
    }),
    );
    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
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
