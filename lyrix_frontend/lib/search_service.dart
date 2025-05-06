import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lyrix_frontend/pages/profileViewer.dart';

//Helper function to get profile information of searched users
Future<Map<String, dynamic>?> getUserInfo(String username) async {
  final url = Uri.parse('http://localhost:8000/get_user?user=$username');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load user info');
  }
}

// Search Service
// This service handles the search functionality for users
// It fetches user data from the backend based on the search query
// and displays the results in a search delegate.
class CustomSearchDelegate extends SearchDelegate {
  Future<List<dynamic>> _searchUsers(String query) async {
    final url = Uri.parse('http://localhost:8000/search_users?query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: snapshot.data![index]["profile_picture"] != "" && snapshot.data![index]["profile_picture"]!.isNotEmpty
                    ? MemoryImage(base64Decode(snapshot.data![index]["profile_picture"]))
                    : AssetImage("assets/profile.png") as ImageProvider
                    ),
                title: Text(results[index]['username'],   
                            style:TextStyle(color: Colors.white, fontSize: 20)),
                onTap: () async{
                  // Fetch user info and navigate to profile viewer
                  await getUserInfo(results[index]['username']).then((userInfo) {
                    if (userInfo != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileViewerPage(
                            username: userInfo['username'],
                            profilePicture: userInfo['profile_picture'],
                          ),
                        ),
                      );
                    }
                  });
                  close(context, results[index]); // Close search and return selected result
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No suggestions available'));
        } else {
          final suggestions = snapshot.data!;
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: snapshot.data![index]["profile_picture"] != "" && snapshot.data![index]["profile_picture"]!.isNotEmpty
                    ? MemoryImage(base64Decode(snapshot.data![index]["profile_picture"]))
                    : AssetImage("assets/profile.png") as ImageProvider,
                ),
                title: Text(suggestions[index]['username'],   
                            style:TextStyle(color: Colors.white, fontSize: 20)),
                onTap: () async{
                  await getUserInfo(suggestions[index]['username']).then((userInfo) {
                    if (userInfo != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileViewerPage(
                            username: userInfo['username'],
                            profilePicture: userInfo['profile_picture'],
                          ),
                        ),
                      );
                    }
                  });
                  
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}