import 'package:flutter/material.dart';
import 'package:lyrix_frontend/pages/create_account.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';

class Profilepage extends StatefulWidget {
  final String username;

  const Profilepage({super.key, required this.username});

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
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profile.png"),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 30), //boxes profile pic controlling the distance between pic and username

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username", // Updated to use passed username
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text(
                    "bio",  //should let users edit this for their bio
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
                )
              )
            ],
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
                    color: showSongs ? Colors.black : Colors.grey,
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
                  color: !showSongs ? Colors.black : Colors.grey,
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
          title: Text("Friend ${index + 1}"),
          subtitle: Text("Mutual friend"),
        );
      },
    );
  }
