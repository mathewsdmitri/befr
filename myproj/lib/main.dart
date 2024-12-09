import 'package:flutter_svg/flutter_svg.dart';

import 'homePage.dart';
import 'userPage.dart';
import 'package:flutter/material.dart';

void main() async {
  //String mystring = getString() as String;
  //print(getString().then(onValue));
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
  List<Map<String, dynamic>> songs = [];

  void updateSongs(List<Map<String, dynamic>> newSongs) {
    setState(() {
      songs = newSongs;
    });
  }

  List<Widget> _widgetOptions() {
    return <Widget>[
      HomePage(songs: songs), // Pass songs to HomePage
      const Text('Post Here',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      UserPage(updateSongs: updateSongs), // Pass the updateSongs function
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
        backgroundColor: Colors.white,
        title: Text(
          'Lyrix',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(
            'assets/icons/chevron-left-icon.svg',
            height: 20,
            width: 20,
          ),
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 37,
              decoration: BoxDecoration(
                  color: Color(0xffF7F8F8),
                  borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(
                'assets/icons/chevron-left-icon.svg',
                height: 20,
                width: 20,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions()[_selectedIndex], // Display the selected widget
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,

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
        selectedItemColor:
            const Color.fromARGB(255, 3, 3, 3), // Change selected item color
        unselectedItemColor:
            const Color.fromARGB(255, 6, 6, 6), // Change unselected item color
      ),
    );
  }
}
