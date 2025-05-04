import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lyrix_frontend/main.dart';

//Profile Viewer Page shows profile of other users
// This page is used when searching for users and clicking on their profile
class ProfileViewerPage extends StatefulWidget {
  final String? username;
  final String? profilePicture;
  const ProfileViewerPage({super.key, required this.username, required this.profilePicture});

  @override
  _ProfileViewerPageState createState() => _ProfileViewerPageState();
}

class _ProfileViewerPageState extends State<ProfileViewerPage> {

  bool showSongs = true; //to help toggle tabs between posted songs and friend list
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Match the app's theme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          widget.username ?? "Profile",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.profilePicture != null && widget.profilePicture!.isNotEmpty
                      ? MemoryImage(base64Decode(widget.profilePicture!))
                      : AssetImage("assets/profile.png") as ImageProvider,
                  backgroundColor: const Color.fromARGB(255, 189, 189, 189),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username ?? "User",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "bio",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => showSongs = true),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Text(
                    "Songs",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: showSongs ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(" |", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
              ),
              GestureDetector(
                onTap: () => setState(() => showSongs = false),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Text(
                    "Friends",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: !showSongs ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: showSongs ? buildSongsGrid() : buildFriendsList(),
          ),
        ],
      ),
    );
  }
}

//Temporary grid for where song coverart could be to show posted songs throughout a users history on the app (grabbed from the database)
Widget buildSongsGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //2 items per row
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 12, //temporary count
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300], //placeholder color
          child: Center(child: Icon(Icons.music_note, size: 40, color: Colors.white)),
        );
      },
    );
  }

  //Temporary friends list (must be changed to grab friends from database)
  Widget buildFriendsList() {
    return ListView.builder(
      padding: EdgeInsets.all(8),                   
      itemCount: 10, //example count
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(backgroundColor: Colors.blueGrey),
          title: Text("Friend ${index + 1}", style: TextStyle(color: Colors.white),),
          subtitle: Text("Mutual friend", style: TextStyle(color: Colors.white),),
        );
      },
    );
  }
