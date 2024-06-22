import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // Check if email or password is empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Email and password must not be empty'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final String apiUrl = 'http://192.168.0.103:3000/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accountEmail': _emailController.text,
          'accountPassword': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Successfully logged in
        final responseData = json.decode(response.body); // Decode response body
        print('Logged in! Response Data: $responseData');
        // Navigate to next screen or perform other actions
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(userData: responseData)));
      } else {
        // Login failed
        print('Login failed. Status code: ${response.statusCode}');
        // Show error message to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid email or password'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print('Error during login: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('An error occurred. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEC), // Background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                  color: Color(0xFF597E52), // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20), // Space between title and text fields
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF597E52), // Border color
                      width: 2.0, // Set width of the border
                    ),
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                    border: InputBorder.none, // Remove the border
                  ),
                ),
              ),
              SizedBox(
                  height: 10), // Space between username and password fields
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF597E52), // Border color
                      width: 2.0, // Set width of the border
                    ),
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true, // Hide password text
                  decoration: InputDecoration(
                    hintText: 'Password', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                    border: InputBorder.none, // Remove the border
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between password field and button
              SizedBox(
                width: 180, // Set width of the button
                child: ElevatedButton(
                  onPressed: _login, // Call _login method
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFFF1E4C3), // Button background color
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: Colors.black, // Set the text color here
                  ),
                  child: Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
