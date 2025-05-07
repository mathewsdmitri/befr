import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lyrix_frontend/account_service.dart';
import 'package:lyrix_frontend/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> posts;  //lists of posts to display
  final String? username;  //Username of current user

  const HomePage({super.key, required this.posts, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> likedPost = {};  //tracks liked status per post by index
  final Map<int, int> numlikesmap = {};
  List<Map<String,dynamic>> _posts = [];

  @override
  void initState(){
  super.initState();
  _posts = widget.posts;
  _fetchLatestPosts();    
  }
  Future<void> _fetchLatestPosts() async {
    final user = await getUser();
    if(user == null)return;

    String baseUrl = 'http://localhost:8000/getFollowingPost?username=$user';
    try{
      final response = await http.get(Uri.parse(baseUrl));
      if(response.statusCode == 200){
        final List<dynamic> jsonPosts = jsonDecode(response.body);
        _posts = List<Map<String, dynamic>>.from(jsonPosts);
        for (int i = 0; i < _posts.length; i++) {
          final userProfile = await loadUser(_posts[i]['username']);
          _posts[i]['profile_picture'] = userProfile['profile_picture'];
        }
        setState(() => _posts = List<Map<String, dynamic>>.from(jsonPosts));

      }
      else{
        print("Failed: ${response.statusCode} ${response.body}");
      }
    }
    catch(e){
      print("It didnt work :(");
    }
  }
  @override
  Widget build(BuildContext context) {
    final currentPosts = _posts;  //store current list of posts

    //print(currentPosts);
    return Scaffold(
      body: currentPosts.isEmpty
      //if no posts exists display no posts
          ? const Center(child: Text("No posts yet", style: TextStyle(color: Colors.white),))
      //if posts exist, show list of posts on feed
          : ListView.separated(
            //tracks number of posts
              itemCount: currentPosts.length,

            //each post in the list will get a post container containing post info
              itemBuilder: (context, index)  {
                final post = currentPosts[index];
                final profile_picture = post['profile_picture'] as String?;
                final trackName = post['track_name'] as String?;
                final albumArtUrl = post['album_url'] as String?;
                final artistName = post['artist_name'] as String?;
                final postAuthor = post['username'] as String?;
              

      return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            //For username on feed
            SizedBox(
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius:23,
                    backgroundImage:  profile_picture != null && profile_picture.isNotEmpty
                      ? MemoryImage(base64Decode(profile_picture))
                      : const AssetImage("assets/profile.png") as ImageProvider,
                    backgroundColor: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Text(
                        postAuthor ?? "User",
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                    ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 10)),

            //For album art in feed
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                albumArtUrl != null && albumArtUrl.isNotEmpty
                  ? ClipRRect( 
                     child: Image.network
                        (
                          albumArtUrl,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                    )
                  : const Icon(Icons.music_note, size: 250, color: Colors.white),
              ],
            ),

            Padding(padding: EdgeInsets.only(top: 5)),

            //For row showing track and artist name
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (trackName != null && trackName.isNotEmpty)
                    Text(
                      '$trackName - $artistName',
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold
                      ),
                    ),
                ],
              ),
            ),

            //For row with comment and like icon
            SizedBox(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,   
                    children: [
                    Icon(Icons.comment_outlined, size: 30, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        "View Comments",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: Colors.white),
                        ),
                    ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          likedPost[index] == true ? Icons.favorite : Icons.favorite_border,
                          color: likedPost[index] == true ? Colors.pink : Colors.white,
                        ),
                        
                        onPressed: () async{
                          const String url = 'http://localhost:8000/like';
                          try {
                            final response = await http.post(
                              Uri.parse(url),
                              headers: {
                                "Content-Type": "application/json",
                              },
                              body: jsonEncode({
                                'username': await getUser(),
                                'post_id': post['post_id'],
                              }),
                            );
                            if (response.statusCode == 200) {
                              //print(response.body);
                              dynamic value = json.decode(response.body);
                              print(numlikesmap[index]);
                              numlikesmap[index] = value['num_likes'];
                              print(numlikesmap[index]);
                            }

                          } catch (e) {
                            print("Request failed: $e");
                         
                          }
                          setState(() {
                            likedPost[index] = !(likedPost[index] ?? false);
                          });
                        },
                      ),
                      
                    ],
                  ),      
                ],
              ),
            ),

            SizedBox(
              width: 218,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${(numlikesmap[index] ?? 0)}'),
                          ],
                        ),
            ), 

            Padding(padding: EdgeInsets.only(top: 5)),

            //row for outputting the user caption
            SizedBox(
              width: 325,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  Column(
                    children: [
                      Text(
                        post['content'] ?? '',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        )
      );
    },

    separatorBuilder: (context, index) => const Divider(color: Colors.white, thickness: 1),
    ),

    );
  }
}
