import 'package:flutter/material.dart';
import 'package:lyrix_frontend/account_service.dart';
import 'package:lyrix_frontend/pages/create_account.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

@override

class _ForgotPassword extends State<ForgotPassword> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password Page',
          style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,)),
        centerTitle: true,
  //      automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // this is where the intro or welcome message is put
            const Text(
              'Please enter your email!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            //This is where the email goes
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
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
                      setState(() {
                        isLoading = true;
                        errorMessage = "";
                      });
                
                      bool success = await sendForgotPassword(
                        context, 
                        username.text.trim(),
                      );
                
                      setState(() {
                        isLoading = false;
                        if (!success) {
                          errorMessage = "Invalid email.";
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      "Try Email",
                      style: TextStyle(color: Colors.black),
                      
                    ),
                  ),
              ),

            const SizedBox(height: 10),
            
            //this is asking for the signup prompt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Cant find your account?"),
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
                    style: TextStyle(color: Colors.black),  
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