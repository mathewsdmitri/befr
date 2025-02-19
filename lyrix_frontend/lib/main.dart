import 'package:flutter/material.dart';
import 'package:lyrix_frontend/pages/create_account.dart';
import 'package:lyrix_frontend/pages/postPage.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';
import 'package:lyrix_frontend/pages/profilePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save UUID
Future<void> saveUUID(String uuid) async {
  await storage.write(key: 'user_uuid', value: uuid);
}

// Get UUID
Future<String?> getUUID() async {
  return await storage.read(key: 'user_uuid');
}

// Remove UUID (Logout)
Future<void> deleteUUID() async {
  await storage.delete(key: 'user_uuid');
}

void main() {
  runApp(const MyApp());
}

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
  List <dynamic> songs = [];

  void updateSongs(List <dynamic> newSongs) {
    setState(() {
      songs = newSongs;
    });
  }

  List<Widget> _widgetOptions() {
  return <Widget>[
    Text('Homepage Feed Under Construction'),
    PostPage(updateSongs: updateSongs),
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