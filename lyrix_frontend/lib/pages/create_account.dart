import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override

  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final controllerName = TextEditingController();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerName.dispose();
    controllerUsername.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Name'),
          _textEntryName('ex. John Doe'),
          _label('Preffered Username'),
          _textEntryUsername(''),
          _label('New Password'),
          _textEntryPassword('Make it strong!'),

          /*
          Container(
            margin: EdgeInsets.only(top: 20, left: 180),
            alignment: Alignment.center,
            height: 45,
            width: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.green
                ]
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          */
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 30),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: ()async{
                  print(controllerName.text);
                  print(controllerUsername.text);
                  print(controllerPassword.text);
                  const String url = "http://localhost:8000/register_user";
                  var body = jsonEncode({
                    'email':controllerName.text,
                    'username' : controllerUsername.text,
                    'password' : controllerPassword.text
                  });
                  final response  = await http.post(Uri.parse(url),
                    headers: {"Content-Type": "application/json"},
                    body:body);
                  print("${response.statusCode}");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20)
                ),
                child: const Text('Confirm'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column _label(String label){
    return Column(
            children: [
              const SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left:30),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 49, 49, 49),
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                )
              )
            ],
    );
  }

  Container _textEntryName(String example){
    return Container(
            margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 161, 146, 146),
                  blurRadius: 10,
                  spreadRadius: 0.0,
                )
              ]
            ),
            child: TextField(
              controller: controllerName,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                hintText: example,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 194, 186, 186),
                ),
                /*prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Search.svg'),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/icons/Filter.svg'),
                ),
                */
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            )
    );
  }Container _textEntryUsername(String example){
    return Container(
            margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 161, 146, 146),
                  blurRadius: 10,
                  spreadRadius: 0.0,
                )
              ]
            ),
            child: TextField(
              controller: controllerUsername,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                hintText: example,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 194, 186, 186),
                ),
                /*prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Search.svg'),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/icons/Filter.svg'),
                ),
                */
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            )
    );
  }Container _textEntryPassword(String example){
    return Container(
            margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 161, 146, 146),
                  blurRadius: 10,
                  spreadRadius: 0.0,
                )
              ]
            ),
            child: TextField(
              controller: controllerPassword,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                hintText: example,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 194, 186, 186),
                ),
                /*prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Search.svg'),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/icons/Filter.svg'),
                ),
                */
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            )
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
  //    automaticallyImplyLeading: false, //Gets rid of backarrow caused by new appbar
      title: const Text(
        "Create Account",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
  //    backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      
    );
  }
}