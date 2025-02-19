import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  final Function(List <dynamic>) updateSongs;
  const PostPage({super.key, required this.updateSongs});

  @override
  // ignore: library_private_types_in_public_api
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool hasPosted = false; //Track if a post has already been posted
  String? selectedOption;
  final TextEditingController captionController = TextEditingController();

  //List of predefined dropdown options (will be replaced with backend data later)
  List<dynamic> options = ["Song 1", "Song 2", "Song 3"];

  Future <List <dynamic>> listSongs() async{
    const String url = 'http://localhost:8000/getRecentlyPlayed';
    const String uniqueID = 'qwert';
    final response = await http.get(Uri.parse('$url?uuid=$uniqueID'));
    List <dynamic> data = jsonDecode(response.body);
    options = data;
    print(data);
    widget.updateSongs(data);
    return data;
  }

  void showPostDialog() {
    if (hasPosted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have already posted")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Make a Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [     
                //Dropdown menu
              DropdownButton<String>(
                value: selectedOption,
                hint: const Text("Select a song"),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    print(options);
                    selectedOption = newValue;
                  });
                  print('selected song: $selectedOption');
                  Navigator.of(context).pop();
                  showPostDialog(); //Reopen dialog to reflect selection
                },
                items: options.map((dynamic option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              //Show caption input only after an option is selected
              if (selectedOption != null)
                TextField(
                  controller: captionController,
                  decoration: const InputDecoration(hintText: "Enter a caption..."),
                  maxLength: 120,
                ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: selectedOption == null
                    ? null //Disable button if a selection isn't made
                    : () {
                        setState(() {
                          hasPosted = true; //Track that a post has been made
                        });
                        String caption = captionController.text;
                        print('caption: $caption');
                        Navigator.of(context).pop(); //Close dialog
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
          const Text("Add Post", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5), // Space between text and icon
          IconButton(
            onPressed: ()async {
    //          options = await listSongs();  //THIS IS FOR GETTIN LIST OF SONGS
              showPostDialog();
              }, 
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.black,
            iconSize: 50, 
          ),
        ],
      ),
    );
  }
}