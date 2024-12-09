import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'enviromentVariables.dart';

class UserPage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) updateSongs;
  final String uniqueID;
  const UserPage(
      {super.key, required this.updateSongs, required this.uniqueID});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void launchSpotify() async {
    final String baseUrl = EnviromentVariables.baseUrl;
    final String uniqueID = widget.uniqueID;
    final response =
        await http.get(Uri.parse('${baseUrl}login?uniqueID=$uniqueID'));
    dynamic data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print(data);
      data = Uri.parse(data);
    } else {
      throw Exception('HTTP Failed');
    }
    if (!await launchUrl(data, mode: LaunchMode.externalApplication)) {
      throw Exception('COULD NOT LOAD $response');
    }
  }

  Future<void> listSongs() async {
    final String baseUrl = EnviromentVariables.baseUrl;
    final String uniqueID = widget.uniqueID;
    final response = await http
        .get(Uri.parse('${baseUrl}getlistofsongs?uniqueID=$uniqueID'));
    //   dynamic data;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<Map<String, dynamic>> songList = data.map((song) {
        return {
          'track_name': song['track_name'],
          'artist_name': song['artist_name'],
        };
      }).toList();

      widget.updateSongs(songList); //Update the songs in HomePage
    } else {
      throw Exception('HTTP Failed Here');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), //Custom height for the AppBar
        child: Container(
          padding: const EdgeInsets.all(10), //Add padding to bring it down
          color: Colors.white, //AppBar background color
          child: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'User Login',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: launchSpotify, child: const Text("Spotify Login")),
            ElevatedButton(
                onPressed: listSongs, child: const Text("Get list of songs"))
          ],
        ),
      ),
    );
  }
}
