import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({ Key? key }) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
void launchSpotify() async {
  final Uri url = Uri.parse('https://accounts.spotify.com/en/login?continue=https%3A%2F%2Faccounts.spotify.com%2Fauthorize%3Fscope%3Duser-read-recently-played%26response_type%3Dcode%26redirect_uri%3Dhttp%253A%252F%252Flocalhost%253A8000%252Fcallback%26client_id%3D4ed1d5e40bfd4a14a02b8f901dd913cd');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('COULD NOT LOAD $url');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: PreferredSize(
    preferredSize: const Size.fromHeight(60), //Custom height for the AppBar
    child: Container(
      padding: const EdgeInsets.all(10), //Add padding to bring it down
      color: Colors.white, //AppBar background color
      child: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'User Login',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
    ),
  ),
  body: Center(
    child: ElevatedButton(
      onPressed: launchSpotify,
      child: const Text('Spotify Login'),
    ),
  ),
);
  }
}

