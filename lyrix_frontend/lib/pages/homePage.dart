import 'dart:convert';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> posts; //List of posts passed to the HomePage

  const HomePage({super.key, required this.posts}); //Constructor to accept posts list

  @override
  Widget build(BuildContext context) {
    return posts.isEmpty //Check if there are no posts
        ? const Center(child: Text("No posts yet")) //Display message if no posts
        : ListView.separated( 
            itemCount: posts.length, 
            itemBuilder: (context, index) {
              final post = posts[index]; //Get the current post
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16), //Margin around each card
                child: Padding(
                  padding: const EdgeInsets.all(15.0), //Padding for inside card
                  child: ListTile(
                    title: Text(
                      post["song"] ?? "No Song", //Display song or "No Song" if song is null
                      style: const TextStyle(fontWeight: FontWeight.bold), 
                    ),
                    subtitle: Text(post["caption"] ?? ""), //Display caption if exists
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
