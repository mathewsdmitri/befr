import 'dart:convert';
import 'package:flutter/material.dart';

// class HomePage extends StatefullsWidget {
//   final List<Map<String, String>> posts; //List of posts passed to the HomePage
  

//   HomePage({super.key, required this.posts}); //Constructor to accept posts list

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  const HomePage({super.key, required this.posts});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> likedPost = {};

  @override
  Widget build(BuildContext context) {
    return widget.posts.isEmpty //Check if there are no posts
        ? const Center(child: Text("No posts yet")) //Display message if no posts
        : ListView.separated( 
            itemCount: widget.posts.length, 
            itemBuilder: (context, index) {
              final post = widget.posts[index]; //Get the current post
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16), //Margin around each card
                child: Padding(
                  padding: const EdgeInsets.all(15.0), //Padding for inside card
                  child: 
                  ListTile(
                    title: Text(
                      post["song"] ?? "No Song", //Display song or "No Song" if song is null
                      style: const TextStyle(fontWeight: FontWeight.bold), 
                    ),
                    subtitle: Text(post["caption"] ?? ""), //Display caption if exists
                    trailing: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            likedPost[index] == true ? Icons.favorite : Icons.favorite_border,
                            color: likedPost[index] == true ? Colors.pink : Colors.grey[700], 
                          ),
                          onPressed: () {
                            setState(() {
                                  likedPost[index] = !(likedPost[index] ?? false);
                                });
                          },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider( 
                color: Colors.grey, 
                thickness: 1, 
              );
            },
          );
  }
}
