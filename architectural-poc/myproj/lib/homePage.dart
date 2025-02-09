import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'enviromentVariables.dart';

class HomePage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) getSongPosts;
  final List<Map<String, dynamic>> postedSongs;
  final String uniqueID;
  const HomePage({
    super.key,
    required this.postedSongs,
    required this.uniqueID,
    required this.getSongPosts,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Category> categories = [
    Category(
        name: 'Pop', iconPath: 'assets/icons/pop.svg', boxColor: Colors.blue),
    Category(
        name: 'Rock', iconPath: 'assets/icons/rock.svg', boxColor: Colors.red),
    // Add more categories here
  ];

  Future<void> getPostedSongs() async {
    final String baseUrl = EnviromentVariables.baseUrl;
    final response = await http.get(Uri.parse('${baseUrl}getSongPosts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<Map<String, dynamic>> songList = data.map((song) {
        return {
          'post': song['post'],
          'uuid': song['uuid'],
        };
      }).toList();
      widget.getSongPosts(songList);
    } else {
      throw Exception('HTTP Failed Here');
    }
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Genre',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(categories[index].iconPath),
                      ),
                    ),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          _categoriesSection(), // Add the categories section here
          Expanded(
            child: widget.postedSongs.isEmpty
                ? ElevatedButton(
                    onPressed: getPostedSongs,
                    child: const Text("Press for Refresh"),
                  )
                : ListView.separated(
                    itemCount: widget.postedSongs.length,
                    itemBuilder: (context, index) {
                      final songPosts = widget.postedSongs[index];
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songPosts['post'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              songPosts['uuid'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Colors.black, thickness: 1);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() => AppBar(
        title: const Text(''),
        centerTitle: true,
      );
}

class Category {
  final String name;
  final String iconPath;
  final Color boxColor;

  Category(
      {required this.name, required this.iconPath, required this.boxColor});
}
