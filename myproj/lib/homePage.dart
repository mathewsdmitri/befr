import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'enviromentVariables.dart';

class HomePage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) getSongPosts;
  final List<Map<String, dynamic>> postedSongs;
  final String uniqueID;
  const HomePage(
      {super.key,
      required this.postedSongs,
      required this.uniqueID,
      required this.getSongPosts});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> getPostedSongs() async {
    final String baseUrl = EnviromentVariables.baseUrl;
    final response = await http.get(Uri.parse('${baseUrl}getSongPosts'));
    //   dynamic data;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<Map<String, dynamic>> songList = data.map((song) {
        return {
          'post': song['post'],
          'uuid': song['uuid'],
        };
      }).toList();
      widget.getSongPosts(songList); //Update the songs in HomePage
    } else {
      throw Exception('HTTP Failed Here');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: const Text('HomePage'), centerTitle: true),
        body: widget.postedSongs.isEmpty
            ? ElevatedButton(
                onPressed: getPostedSongs,
                child: const Text("Press for Refresh"))
            : ListView.separated(
                itemCount: widget.postedSongs.length,
                itemBuilder: (context, index) {
                  final songPosts = widget.postedSongs[index];
                  return ListTile(
                      title: Text(songPosts['post']),
                      subtitle: Text(songPosts['uuid']));
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.black, thickness: 1);
                }));
  }
}
