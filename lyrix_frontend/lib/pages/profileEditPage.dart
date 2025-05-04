import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:lyrix_frontend/main.dart';
import 'package:http/http.dart' as http;

void uploadProfilePicture(String base64Image) async {
  final String baseUrl = 'http://localhost:8000/updateProfilePic';
  String? username = await getUser();
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'profile_picture': base64Image,
      'email': "",
      'bio': "",
    }),
  );
}

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
  
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _bioController = TextEditingController();
  XFile? _profileImage;
  

  Future<void> _pickImage() async {
if (kIsWeb) {
    // Use FilePicker for web
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.bytes != null) {
      //Encode Picture and Do API Call to save picture
      //Encoding picture for mongoDB

      //Make API call to save the image with base url: localhost:8

      setState(() {
        _profileImage = XFile.fromData(
          result.files.single.bytes!,
          name: result.files.single.name,
        );
      });
    }
  } else {
    // Use ImagePicker for mobile platforms
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }
  }

  void _saveProfile() async {
    final String bio = _bioController.text;
    // Handle saving the profile picture and bio
    print('Bio: $bio');
    print('Profile Image: ${_profileImage?.path}');
    if(_profileImage != null) {
      // Encode the image to base64
      Uint8List imageBytes = await _profileImage!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      uploadProfilePicture(base64Image);
    }
    if(bio.isNotEmpty) {
      // Make API call to save the bio
      final String baseUrl = 'http://localhost:8000/update_bio';
      String? username = await getUser();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'profile_picture': "",
          'email': "",
          'bio': bio,
        }),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path))
                    : null,
                child: _profileImage == null
                    ? Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}