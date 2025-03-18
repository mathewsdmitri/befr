import 'package:flutter/material.dart';
import 'package:lyrix_frontend/pages/create_account.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';


class Profilepage extends StatefulWidget {
  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profile.png"),
                backgroundColor: Colors.grey,
              ),
              SizedBox(width: 30), //boxes profile pic controlling the distance between pic and username

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username",  //should grab the username of the current user
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "bio",  //should let users edit this for their bio
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal
                    ),
                  )
                ],
                )
              )
            ],
          ),
        ),
        Row(
          
        )
      ],
    );
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center( //Centers everything in the middle of page
  //       child: Column( //Buttons are put in columns in center
  //         mainAxisSize: MainAxisSize.min,
  //         children: [

  //           //Elevated button 1 for create page
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return const Scaffold(
  //                   body: CreateAccountPage(), //Create account page
  //                 );
  //               }));
  //             },
  //             style: ElevatedButton.styleFrom(backgroundColor: Colors.black), //Background color of button
  //             child: const Text('Create Account', style: TextStyle(color: Colors.white)), //Text and color
  //           ),
  //           const SizedBox(height: 20), //Controls size between buttons
            
  //           //Elevated button 2 for login page
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return const Scaffold(
  //                   body: LoginPage(), //Login page
  //                 );
  //               }));
  //             },
  //             style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
  //             child: const Text('Login', style: TextStyle(color: Colors.white)),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
