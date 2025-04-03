import 'package:flutter/material.dart';
import 'package:lyrix_frontend/account_service.dart';
import 'package:lyrix_frontend/pages/create_account.dart';
import 'package:lyrix_frontend/pages/forgot_password.dart';
import 'package:lyrix_frontend/pages/homePage.dart';
import 'package:lyrix_frontend/pages/profilePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 3
          )
        ),
        title: const Text(
          'Login Page',
          style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,)),
        centerTitle: true,
  //      automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // this is where the intro or welcome message is put
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold, color: Colors.white
              ),
            ),
            const SizedBox(height: 20),

            //This is where the username/email goes
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: username,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Email or Username',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: password,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: true
                
              ),
            ),
                        // Show error message if login fails
            if (errorMessage.isNotEmpty) 
              Text(errorMessage, style: const TextStyle(color: Colors.red)),

            isLoading 
              ? const CircularProgressIndicator() // Show loading spinner
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      print("Login button here");
                      print("Username: ${username.text.trim()}");
                      print("Password: ${password.text.trim()}");

                      setState(() {
                        isLoading = true;
                        errorMessage = "";
                      });
                
                      bool success = await sendLoginRequest(
                        context, 
                        username.text.trim(), 
                        password.text.trim(),
                      );
                      
                
                      setState(() {
                        isLoading = false;
                        if (!success) {
                          errorMessage = "Invalid email or password.";
                        }else{
                          Navigator.pushReplacementNamed(
                              context, "/home");
                        } 
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                      
                    ),
                  ),
              ),

            const SizedBox(height: 10),
            
            //The link for forgotten password
            //Elevated button 1 for create page
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Scaffold(
                    body: ForgotPassword(), //Create account page
                  );
                }));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white), //Background color of button
              child: const Text('Forgot Password', style: TextStyle(color: Colors.black)), //Text and color
            ),
            const SizedBox(height: 20),
            

            //this is where the login button goes
            /*SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            */

            //this is asking for the signup prompt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Need an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const Scaffold(
                        body: CreateAccountPage(), //Create account page
                      );
                    }));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white),  
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
