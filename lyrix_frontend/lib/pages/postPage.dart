import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lyrix_frontend/main.dart';

class PostPage extends StatefulWidget {
//  final Function(List <dynamic>) updateSongs;
 // const PostPage({super.key, required this.updateSongs});
  
 final Function(String song, String? albumArtUrl, String caption) addPost;
  const PostPage({super.key, required this.addPost}); 
  @override
  // ignore: library_private_types_in_public_api
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool hasPosted = false; //Track if a post has already been posted
  String? selectedOption;
  final TextEditingController captionController = TextEditingController();

  //List of predefined dropdown options (will be replaced with backend data later)
  late List<dynamic> options;

  Future <List <dynamic>> listSongs() async{
    const String url = 'http://localhost:8000/getRecentlyPlayed';
    String? uniqueID = await getUUID();
    final response = await http.get(Uri.parse('$url?uuid=$uniqueID'));
    List <dynamic> data = jsonDecode(response.body);
            return data.map((song) {
          return {
            'track_name': song['track_name'],
            'artist_name': song['artist_name'],
            'album_art_url': song['album_art_url']
          };
        }).toList();
  }

  void showPostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Make a Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dropdown menu
              DropdownButton<String>(
                value: selectedOption,
                hint: const Text("Select a song"),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                  print('Selected song: $selectedOption');
                  // Close & reopen to force rebuild with new selectedOption
                  Navigator.of(context).pop();
                  showPostDialog();
                },
                items: options.map((dynamic option) {
                  return DropdownMenuItem<String>(
                    value: option['track_name'],
                    child: Row(
                      children: [
                        // Display album art if available
                        if (option['album_art_url'] != null &&
                            option['album_art_url'].isNotEmpty)
                          Image.network(
                            option['album_art_url'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        else
                          const Icon(Icons.music_note),
                        const SizedBox(width: 8),
                        Text(option['track_name']),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // Show caption input only after an option is selected
              if (selectedOption != null)
                TextField(
                  controller: captionController,
                  decoration:
                      const InputDecoration(hintText: "Enter a caption..."),
                  maxLength: 120,
                ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                                // Find the track that matches the selectedOption
                                final chosenTrack = options.firstWhere(
                                (track) => track['track_name'] == selectedOption,
                                orElse: () => <String, dynamic>{}, // Return an empty map if none is found
                                );

                                // Safely retrieve the album art URL (can be null if not present)
                                final String? albumArtUrl = chosenTrack?['album_art_url'] as String?;

                                // Call the parent’s callback to add the post
                                widget.addPost(
                                  selectedOption!,         // Non-null track name
                                  albumArtUrl,            // Nullable album art
                                  captionController.text, // User's caption
                                );

                                Navigator.of(context).pop(); // Close dialog

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Post submitted!")),
                                );
                              },
                child: const Text("Post"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Post",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5), // Space between text and icon
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.black,
            iconSize: 50,
            onPressed: () async {
              options = await listSongs(); // Fetch list of songs from your backend
              print(options);
              showPostDialog();
            },
          ),
        ],
      ),
    );
  }
}