import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lyrix_frontend/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';

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
                      Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
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
                child: const Text('Link Account to Spotify!'),
              ),
            ),
          ),
        ]
      ),
    );
  }
}