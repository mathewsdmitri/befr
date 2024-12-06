import 'userService.dart';
import 'userPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> songs;

  const HomePage({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(''), centerTitle: true),
      body: songs.isEmpty
          ? const Center(child: Text('No songs available'))
          : ListView.separated(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song['track_name']),
                  subtitle: Text(song['artist_name']),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: Colors.black, thickness: 1);
              },
            ),
    );
  }
}
