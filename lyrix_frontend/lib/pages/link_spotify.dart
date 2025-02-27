import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LinkSpotify extends StatefulWidget {
  const LinkSpotify({super.key});

  @override

  State<LinkSpotify> createState() => _LinkSpotify();
}

@override

class _LinkSpotify extends State<LinkSpotify> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 30),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: ()async{
                  print("This is where the backend should switch to linking to spotify");
                },
                child: const Text('Link Account to Spotify!'),
              ),
            ),
          ),
        ]
      ),
    );
  }
}