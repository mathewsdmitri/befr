import 'package:flutter/material.dart';
import 'package:lyrix_frontend/account_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
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
        title: const Text('Login Page',
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
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            //This is where the email goes
            TextField(
              controller: username,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ), 
            TextField(
              controller: password,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                obscureText: false
              
            ),
                        // Show error message if login fails
            if (errorMessage.isNotEmpty) 
              Text(errorMessage, style: TextStyle(color: Colors.red)),

            isLoading 
              ? CircularProgressIndicator() // Show loading spinner
              : ElevatedButton(
                  onPressed: () async {
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
                      }
                    });
                  },
                  child: Text("Login"),
                ),

            const SizedBox(height: 10),
            
            //The link for forgotten password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password!'),
              ),
            ),
            const SizedBox(height: 20),
            

            //this is where the login button goes
            SizedBox(
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

            //this is asking for the signup prompt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Need an account?"),
                TextButton(
                  onPressed: () {},
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
