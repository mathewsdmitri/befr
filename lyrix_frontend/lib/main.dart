import 'dart:convert';
import 'package:lyrix_frontend/account_service.dart';
import 'package:flutter/material.dart';
import 'package:lyrix_frontend/pages/homePage.dart';
import 'package:lyrix_frontend/pages/postPage.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';
import 'package:lyrix_frontend/pages/profilePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrix_frontend/pages/profileEditPage.dart';
import 'package:http/http.dart' as http;
import 'package:lyrix_frontend/search_service.dart';
const storage = FlutterSecureStorage();
AccountService accountService = AccountService();


// Get UUID
Future<String?> getUUID() async {
  return await storage.read(key: 'user_uuid');
}

// Remove UUID (Logout)
Future<void> deleteUUID() async {
  await storage.delete(key: 'user_uuid');
}

// Get username
Future<String?> getUser() async {
  return await storage.read(key: 'user_username');
}

//Get profile picture
Future<String?> getProfilePicture() async {
  return await storage.read(key: 'profile_picture');
}

Future<Map<String, dynamic>?> getUserData() async {
  String? username = await getUser();
  String? profilePicture = await getProfilePicture(); 
  return {
    'username': username,
    'profile_picture': profilePicture,
  };
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final bool isLoggedIn = await checkLoginStatus();
  print(getUser());
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  const storage = FlutterSecureStorage();
  String? uuid = await storage.read(key: 'user_uuid');
  if (uuid == null) {
    return false; // User is not logged in
  }
  bool gotData = await accountService.loadLoggedInUser(await getUser());
  return uuid != null; // If UUID exists, user is logged in
}

class MyApp extends StatelessWidget {
 final bool isLoggedIn;

 const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'befr demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,      //Background of app
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        //      useMaterial3: false,
      ),
      initialRoute: isLoggedIn? "/home" : "/login",
      routes: {
        "/login": (context) => const LoginPage(),
        "/home": (context) => const MyHomePage(),
        "/settings" : (context) => ProfileEditPage(), 
      }
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
  List <dynamic> songs = [];

  List<Map<String, String?>> posts = [];


  void addPost(String song, String artistName, String albumArtUrl, String caption, String postId) {
    setState(() {
      posts.add({'song': song, 'artistName': artistName, 'album_art_url': albumArtUrl, 'caption': caption, 'post_id': postId});
      });
  }

  List<Widget> _widgetOptions(String username, String? profilePicture) {
  return <Widget>[
    HomePage(posts: posts, username:username),
    PostPage(addPost: addPost),
    Profilepage(username: username, profilePicture:profilePicture),
  ];
  }

void _onItemTapped(int index) {
    setState(() {
       _selectedIndex = index; // Update the selected index
    });
  }

   @override
  Widget build(BuildContext context) {

    return FutureBuilder<Map?>(
    future: getUserData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData || snapshot.data == null) {
        return Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting for data
      }
      String username = snapshot.data!['username'] ?? "Guest User"; // Default to "Guest User" if null
      String? profilePicture = snapshot.data!['profile_picture'];
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Colors.white,     ////if we want a border on lyrix appbar
            width: 1
          )
        ),
        shadowColor: Colors.white,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'lyrix',
            style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Open search text field
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions(username, profilePicture).elementAt(_selectedIndex), // Display the selected widget
      ),
      
      bottomNavigationBar: 
      
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.white, width: 3.0))
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
        
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        
          currentIndex: _selectedIndex, // Highlight the selected item
          onTap: _onItemTapped, // Handle item tap
          selectedItemColor: Colors.lightBlue[200], // Change selected item color
          unselectedItemColor: Colors.white, // Change unselected item color
        ),
      ),
      );
    },
  );
}
}