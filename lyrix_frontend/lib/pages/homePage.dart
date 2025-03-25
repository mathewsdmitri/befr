import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  const HomePage({super.key, required this.posts});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Remove the second "posts" list entirely

  @override
  Widget build(BuildContext context) {
    final currentPosts = widget.posts; // Refer to the widget’s list

    return Scaffold(
      appBar: AppBar(title: const Text('Music Posts')),
      body: currentPosts.isEmpty
          ? const Center(child: Text("No posts yet"))
          : ListView.builder(
              itemCount: currentPosts.length,
              itemBuilder: (context, index) {
                final post = currentPosts[index];
                final albumArtUrl = post['album_art_url'] as String?;
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: albumArtUrl != null && albumArtUrl.isNotEmpty
                        ? Image.network(
                            albumArtUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.music_note),
                    title: Text(post['song'] ?? 'No Song'),
                    subtitle: Text(post['caption'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
