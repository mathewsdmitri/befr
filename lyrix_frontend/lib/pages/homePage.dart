import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final String? username;

  const HomePage({super.key, required this.posts, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> likedPost = {};

  @override
  Widget build(BuildContext context) {
    final currentPosts = widget.posts;

    return Scaffold(
      body: currentPosts.isEmpty
          ? const Center(child: Text("No posts yet", style: TextStyle(color: Colors.black),))
          : ListView.separated(
              itemCount: currentPosts.length,
              itemBuilder: (context, index) {
                final post = currentPosts[index];
                final albumArtUrl = post['album_art_url'] as String?;

      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                        widget.username ?? "User",
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                    ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                albumArtUrl != null && albumArtUrl.isNotEmpty
                  ? ClipRRect( 
                     child: Image.network
                        (
                          albumArtUrl,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                    )
                  : const Icon(Icons.music_note, size: 250),
              ],
            ),

            SizedBox(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,   
                    children: [
                    Icon(Icons.comment_outlined, size: 30),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        "View Comments",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
                        ),
                    )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          likedPost[index] == true ? Icons.favorite : Icons.favorite_border,
                          color: likedPost[index] == true ? Colors.pink : Colors.black,
                        ),
                        
                        onPressed: () {
                          setState(() {
                            likedPost[index] = !(likedPost[index] ?? false);
                          });
                        },
                      ),
                    ],
                  ),        
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  post['caption'] ?? '',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ],
            ),

          ],
        )
      );
    },

    separatorBuilder: (context, index) => const Divider(color: Colors.black, thickness: 1),
    ),

    );
  }
}
