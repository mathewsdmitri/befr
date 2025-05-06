import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lyrix_frontend/main.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkSpotify extends StatefulWidget {
  const LinkSpotify({super.key});

  @override

  State<LinkSpotify> createState() => _LinkSpotify();
}

@override

class _LinkSpotify extends State<LinkSpotify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 3
          )
        ),
        title: const Text(
          'Link to Spotify',
          style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,)
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 30),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: ()async{
                  String? uuid = await getUUID();
                  String test = uuid.toString();
                  test.replaceAll('"', '');
                  print(test);
                  print(uuid);
                  const String url = 'http://localhost:8000/spotifyAuth'; // FastAPI endpoint
                  try {
                    final response = await http.get(Uri.parse('$url?uniqueID=${test.trim()}'));
                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      data = Uri.parse(data);
                      print(data);
                      Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                            (route) => false, //this removes all previous routes and navigates to homepage
                          );
                      if (!await launchUrl(data, mode: LaunchMode.externalApplication)) {
                        throw Exception('COULD NOT LOAD $response');
                      }
                    } else {
                      print("Error: ${response.statusCode} - ${response.body}");
                    }
                  } catch (e) {
                    print("Request failed: $e");
                  }
                },
                child: const Text('Link Account to Spotify!', style: TextStyle(color: Colors.black),),
              ),
            ),
          ),
        ]
      ),
    );
  }
}