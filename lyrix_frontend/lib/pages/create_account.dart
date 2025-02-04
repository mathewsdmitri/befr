import 'dart:math';

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
            margin: EdgeInsets.only(top: 30),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: (){
                  print(Text(controllerName.text));
                  print(Text(controllerUsername.text));
                  print(Text(controllerPassword.text));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20)
                ),
                child: Text('Confirm'),
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
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left:30),
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 49, 49, 49),
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
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 161, 146, 146),
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
                contentPadding: EdgeInsets.all(15),
                hintText: example,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 194, 186, 186),
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
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 161, 146, 146),
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
                contentPadding: EdgeInsets.all(15),
                hintText: example,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 194, 186, 186),
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
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 161, 146, 146),
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
                contentPadding: EdgeInsets.all(15),
                hintText: example,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 194, 186, 186),
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
      title: Text(
        "Create Account",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: (){
          
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
        )

      ),
      actions: [
        GestureDetector(
          onTap: (){
            
          },
          child: Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/dots.svg',
              height: 20,
              width: 20,
            ),
          ),
        )
      ],
    );
  }
}