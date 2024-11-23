import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getString() async {
  final response =
      await http.get(Uri.parse("http://10.0.2.2:8000/login")); //USE 127.0.0.1:8000 FOR WEB OR 10.0.2.2:8000 FOR ANDROID
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('HTTP Failed');
  }
}
