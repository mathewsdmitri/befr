import 'package:flutter/material.dart';
import 'package:lyrix_frontend/pages/create_account.dart';
import 'package:lyrix_frontend/pages/loginPage.dart';


class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( //Centers everything in the middle of page
        child: Column( //Buttons are put in columns in center
          mainAxisSize: MainAxisSize.min,
          children: [

            //Elevated button 1 for create page
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Scaffold(
                    body: CreateAccountPage(), //Create account page
                  );
                }));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black), //Background color of button
              child: const Text('Create Account', style: TextStyle(color: Colors.white)), //Text and color
            ),
            const SizedBox(height: 20), //Controls size between buttons
            
            //Elevated button 2 for login page
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Scaffold(
                    body: LoginPage(), //Login page
                  );
                }));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}