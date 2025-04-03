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
          ? const Center(child: Text("No posts yet", style: TextStyle(color: Colors.white),))
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
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius:23,
                    backgroundImage: AssetImage("assets/profile.png"),
                    backgroundColor: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                        widget.username ?? "User",
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                    ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 10)),

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
                  : const Icon(Icons.music_note, size: 250, color: Colors.white),
              ],
            ),

            Padding(padding: EdgeInsets.only(top: 5)),

            SizedBox(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,   
                    children: [
                    Icon(Icons.comment_outlined, size: 30, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        "View Comments",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: Colors.white),
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
                          color: likedPost[index] == true ? Colors.pink : Colors.white,
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

            Padding(padding: EdgeInsets.only(top: 5)),

            SizedBox(
              width: 325,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  Column(
                    children: [
                      Text(
                        post['caption'] ?? '',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        )
      );
    },

    separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 1),
    ),

    );
  }
}
