import 'dart:convert';
import 'package:flutter/material.dart';
class Profilepage extends StatefulWidget {
  final String? username;
  final String? profilePicture;
  final String? bio; 
  const Profilepage({super.key, required this.username, required this.profilePicture, required this.bio});
  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {

  bool showSongs = true; //to help toggle tabs between posted songs and friend list

@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50, 
                // If you have a profile picture in base64, decode it and set it here
                backgroundImage: widget.profilePicture != null && widget.profilePicture!.isNotEmpty
                    ? MemoryImage(base64Decode(widget.profilePicture!))
                    : AssetImage("assets/profile.png") as ImageProvider,
                backgroundColor: Color.fromARGB(255, 189, 189, 189),
              ),
              const SizedBox(width: 30), //boxes profile pic controlling the distance between pic and username
              // Settings Icon that leads to profile settings page

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.username ?? "User", // Updated to use passed username
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 5),
                  Text(
                    widget.bio ?? "Bio",  //should let users edit this for their bio
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  
                ],
                )
              )
            , IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Navigate to settings page
                  Navigator.pushNamed(context, '/settings');
                },
              ),],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector (
              onTap: () => setState(() => showSongs = true),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                "Friends",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: !showSongs ? Colors.white : Colors.grey,
                ),
              ),
            ),
          )
        ],
        ),

        Expanded(
          child: showSongs ? buildSongsGrid() : buildFriendsList(),
        ),

      ],
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
