import 'package:flutter/material.dart';
import 'login.dart'; // Ensure this is correctly defined and imported
import 'signup.dart'; // Ensure this is correctly defined and imported

class Aftersplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<Aftersplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEC), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logoduit.png', height: 200), // Logo
            SizedBox(height: 50), // Space between logo and buttons
            SizedBox(
              width: 180, // Set the desired button width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen()), // Navigate to LoginScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1E4C3),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  foregroundColor: Colors.black, // Set the text color here
                ),
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 20), // Space between buttons
            SizedBox(
              width: 180, // Set the desired button width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignupScreen()), // Navigate to SignUpScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF1E4C3),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  foregroundColor: Colors.black, // Set the text color here
                ),
                child: Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
