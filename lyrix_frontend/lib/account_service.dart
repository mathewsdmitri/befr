import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

const storage = FlutterSecureStorage(); // Secure storage instance

class AccountService {
  Future<bool> sendLoginRequest(
      BuildContext context, String username, String password) async {
    const String url = 'http://localhost:8000/login'; // FastAPI endpoint
    String usernameTest = "";
    String emailTest = "";
    if (username.contains('@')) {
      emailTest = username;
    } else {
      usernameTest = username;
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
          'username': usernameTest,
          'email': emailTest,
          'password': password,
          'bio': "",
          'access_token': "",
          'refresh_token': ""
        }),
      );
      if (response.statusCode == 200) {
        dynamic value = json.decode(response.body);
        String uuid = value['uuid'];
        String username = value['username'];
        await storage.write(key: 'user_uuid', value: uuid); // Store UUID
        await storage.write(
            key: 'user_username', value: username); //Store username

        if (value['access_token'] != null) {
          await storage.write(
              key: 'access_token', value: value['access_token']);
        }

        if (value['refresh_token'] != null) {
          await storage.write(
              key: 'refresh_token', value: value['refresh_token']);
        }
        bool gotData = await loadLoggedInUser(username);
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
    const String url =
        'http://localhost:8000/forgot_password'; // FastAPI endpoint
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
  Future<bool> loadLoggedInUser(String? username) async {
    const String url = 'http://localhost:8000/get_user'; // FastAPI endpoint
    try {
      final response = await http.get(
        Uri.parse('$url?user=$username'),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        var data = response.body;
        print(data);
        dynamic value = json.decode(data);
        String bio = value['bio'];
        String profilePicture = value['profile_picture'];
        List<String> followers = List<String>.from(value['followers']);
        List<String> following = List<String>.from(value['following']);
        storage.write(key: 'bio', value: bio);
        //Convert profile picture back to appropriate format
        storage.write(key: 'profile_picture', value: profilePicture);
        storage.write(key: 'followers', value: jsonEncode(followers));
        storage.write(key: 'following', value: jsonEncode(following));
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
}
