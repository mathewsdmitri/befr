import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class UserService {
  Future<List<Map<String, dynamic>>> launchSpotify() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/login'));
    dynamic data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      data = Uri.parse(data);
    } else {
      throw Exception('HTTP Failed');
    }
    if (!await launchUrl(data, mode: LaunchMode.externalApplication)) {
      throw Exception('COULD NOT LOAD $response');
    } else {
      final response = await http.get(Uri.parse("http://127.0.0.1:8000/getlistofsongs"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((song) {
          return {
            'track_name': song['track_name'],
            'artist_name': song['artist_name'],
          };
        }).toList();
      } else {
        throw Exception('HTTP Failed Here');
      }
    }
  }
}
