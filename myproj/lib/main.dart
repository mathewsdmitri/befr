import 'postPage.dart';
import 'userPage.dart';
import 'homePage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() async {
  runApp(const MyApp());
}

var uuid = Uuid();
final uniqueID = uuid.v1();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'befr demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //      useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track the currently selected index
  List<Map<String, dynamic>> songs = [];
  List<Map<String, dynamic>> songPosts = [];

  void updateSongs(List<Map<String, dynamic>> newSongs) {
    setState(() {
      songs = newSongs;
    });
  }

  void getSongPosts(List<Map<String, dynamic>> updSongPosts) {
    setState(() {
      songPosts = updSongPosts;
      print(songPosts);
    });
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      // Pass songs to HomePage
      HomePage(
          postedSongs: songPosts,
          uniqueID: uniqueID,
          getSongPosts: getSongPosts),
      PostPage(
        songs: songs,
        uniqueID: uniqueID,
      ),
      UserPage(
          updateSongs: updateSongs,
          uniqueID: uniqueID), // Pass the updateSongs function
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'befr',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions()[_selectedIndex], // Display the selected widget
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

        currentIndex: _selectedIndex, // Highlight the selected item
        onTap: _onItemTapped, // Handle item tap
        selectedItemColor: Colors.yellow, // Change selected item color
        unselectedItemColor: Colors.white, // Change unselected item color
      ),
    );
  }
}
