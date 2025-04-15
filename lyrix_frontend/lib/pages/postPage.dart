import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lyrix_frontend/main.dart';

class PostPage extends StatefulWidget {
//  final Function(List <dynamic>) updateSongs;
 // const PostPage({super.key, required this.updateSongs});
  
 final Function (String song, String artistName, String albumArtUrl, String caption) addPost;
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
    String? uniqueID = await getUUID(); //Get user unique id
    final response = await http.get(Uri.parse('$url?uuid=$uniqueID'));
    List <dynamic> data = jsonDecode(response.body);

    //Format each song into a map with the track info and return list to save as options
        return data.map((song) {
          return {
            'track_name': song['track_name'],
            'artist_name': song['artist_name'],
            'album_art_url': song['album_art_url']
          };
        }).toList();
  }

//Dialog asking user to post a song and caption
  void showPostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Make a Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Dropdown menu to choose a song
            SizedBox(
              width: 700,
              child: DropdownButton<String>(
                menuMaxHeight: 1000,  
                itemHeight: 90,
                value: selectedOption,
                hint: const Text("Select a song"),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;  //whenever a user selects/changes a selection, save the selected song 
                  });
                  print('Selected song: $selectedOption');

                  // Close & reopen to force rebuild with new selectedOption
                  Navigator.of(context).pop();
                  showPostDialog();
                },

                items: options.map((dynamic option) {
                  final String track_name = option['track_name'];
                  final String artist_name = option['artist_name'];
                  final displayText = '$track_name\nBy $artist_name';
                  return DropdownMenuItem<String>(
                    
                    value: option['track_name'],
                    child: Row(
                      children: [
                        // Display album art if available
                        if (option['album_art_url'] != null &&
                            option['album_art_url'].isNotEmpty)
                          Image.network(
                            option['album_art_url'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        else
                          const Icon(Icons.music_note),
                        const SizedBox(width: 30),
                        Flexible(child: Text(displayText)),
                      ],
                    ),
                  );
                }).toList(),
              )
            ),
              const SizedBox(height: 10),

              // Show caption input only after an option is selected
              if (selectedOption != null)
                TextField(
                  controller: captionController,
                  style: const TextStyle(color: Colors.black), //color of input caption
                  decoration:
                    const InputDecoration(
                      hintText: "Enter a caption...",
                      hintStyle: TextStyle(
                        color: Colors.grey
                      ) 
                    ),
                    maxLength: 120,
                    
                ),
              const SizedBox(height: 10),

              //Submit posting
              ElevatedButton(
                onPressed: () async{
                  // Find the track that matches the selectedOption from options
                  final chosenTrack = options.firstWhere(
                    (track) => track['track_name'] == selectedOption,
                    orElse: () => <String, dynamic>{}, // Return an empty map if none is found
                  );

                  //Construct post map to send back
                  
                  // Safely retrieve the album art URL (can be null if not present)
                  final String albumArtUrl = chosenTrack['album_art_url'];
                  //Retrieve artist name
                  final String artistName = chosenTrack?['artist_name'];
                  final String? track = await selectedOption;
                  const String url = 'http://localhost:8000/post'; // FastAPI endpoint
                  try {
                    final response = await http.post(
                      Uri.parse(url),
                      headers: {
                        "Content-Type": "application/json", 
                      },
                      body: jsonEncode({
                        'username': await getUser(),
                        'content': captionController.text,
                        'album_url': albumArtUrl,
                        'track_name': track,
                        'artist_name': artistName,
                        'uniqueId': await getUUID()
                    }),
                    );
                    if (response.statusCode == 200) {
                      print(response.body);
                      dynamic value = json.decode(response.body);
                      
                    } else {
                      print("Error: ${response.statusCode} - ${response.body}");
                    }
                  } catch (e) {
                    print("Request failed: $e");
                  }
                  // Call the parent’s callback to pass the post back to parent using addPost() from main.dart
                  widget.addPost(
                    selectedOption!,         // Non-null track name
                    artistName,            // artist name
                    albumArtUrl,            // Nullable album art
                    captionController.text, // User's caption
                  );

                  Navigator.of(context).pop(); // Close dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Post submitted!")),
                  );
                },
                child: const Text("Post", style: TextStyle(color: Colors.black)),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
          const SizedBox(height: 5), // Space between text and icon
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.white,
            iconSize: 50,
            onPressed: () async {
              options = await listSongs(); // Fetch list of songs from api and store in options list
              print(options);
              if (options.isEmpty){
                showDialog(
                  context: context, 
                  builder: (_){
                    return AlertDialog(
                      title: const Text("No Songs Found. Listen to Something!"),
                    );
                  });
              }else{
              showPostDialog();
              }
            },
          ),
        ],
      ),
    );
  }
}