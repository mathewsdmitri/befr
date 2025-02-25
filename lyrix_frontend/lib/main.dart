import 'package:flutter/material.dart';
import 'package:lyrix_frontend/pages/create_account.dart';
import 'package:lyrix_frontend/pages/homePage.dart';
import 'package:lyrix_frontend/pages/postPage.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';
import 'package:lyrix_frontend/pages/profilePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
final storage = FlutterSecureStorage();


// Get UUID
Future<String?> getUUID() async {
  return await storage.read(key: 'user_uuid');
}

// Remove UUID (Logout)
Future<void> deleteUUID() async {
  await storage.delete(key: 'user_uuid');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final bool isLoggedIn = await checkLoginStatus();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  final storage = FlutterSecureStorage();
  String? uuid = await storage.read(key: 'user_uuid');
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
         primarySwatch: Colors.blue,
        //      useMaterial3: false,
      ),
      initialRoute: isLoggedIn? "/home" : "/login",
      routes: {
        "/login": (context) => LoginPage(),
        "/home": (context) => MyHomePage(),
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

  // void updateSongs(List <dynamic> newSongs) {
  //   setState(() {
  //     songs = newSongs;
  //   });
  //}
  List<Map<String, String>> posts = [];

  void addPost(String song, String caption) {
    setState(() {
      posts.insert(0, {"song": song, "caption": caption});
    });
  }

  List<Widget> _widgetOptions() {
  return <Widget>[
    HomePage(posts: posts),
    PostPage(addPost: addPost),
    Profilepage(),
  ];
  }

void _onItemTapped(int index) {
    setState(() {
       _selectedIndex = index; // Update the selected index
    });
  }

   @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'lyrix',
            style: TextStyle(color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions()
            .elementAt(_selectedIndex), // Display the selected widget
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
            label: 'More',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

        currentIndex: _selectedIndex, // Highlight the selected item
        onTap: _onItemTapped, // Handle item tap
        selectedItemColor: Colors.lightBlue, // Change selected item color
        unselectedItemColor: Colors.white, // Change unselected item color
      ),
      );
  }
}