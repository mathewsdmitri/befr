import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatelessWidget {
  final List<Map<String, dynamic>> songs;
  final String uniqueID;
  final String baseUrl;
  const PostPage(
      {super.key,
      required this.songs,
      required this.uniqueID,
      required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage'), centerTitle: true),
      body: songs.isEmpty
          ? const Center(child: Text('No songs available'))
          : ListView.separated(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song['track_name']),
                  subtitle: Text(song['artist_name']),
                  onTap: () async {
                    String postSong =
                        song['track_name'] + " By " + song['artist_name'];
                    final response = await http.post(Uri.parse(
                        '${baseUrl}postSong?selectedSong=$postSong&uuid=$uniqueID'));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: Colors.black, thickness: 1);
              },
            ),
    );
  }
}
