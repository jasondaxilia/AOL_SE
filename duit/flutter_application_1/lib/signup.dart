import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _submitForm() async {
    setState(() {
      _firstNameError = _validateName(_firstNameController.text, 'First Name');
      _lastNameError = _validateName(_lastNameController.text, 'Last Name');
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError =
          _validateConfirmPassword(_confirmPasswordController.text);

      if (_firstNameError == null &&
          _lastNameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null) {
        // Form is valid, submit the data
        _postFormDataToDatabase();
      }
    });
  }

  Future<void> _postFormDataToDatabase() async {
    final String apiUrl = 'http://192.168.0.103:3000/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'accountName': _firstNameController.text + _lastNameController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'accountEmail': _emailController.text,
          'accountPassword': _passwordController.text,
          'balance': '0',
        },
      );

      if (response.statusCode == 201) {
        // Account created successfully
        print('Account created successfully!');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else if (response.statusCode == 400) {
        // Handle specific error cases
        final Map<String, dynamic> responseData = json.decode(response.body);
        final errorMessage = responseData['message'];
        print('Account creation failed: $errorMessage');
      } else {
        // Other error cases
        print('Account creation failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Error occurred during account creation
      print('Error during account creation: $error');
    }
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEC), // Background color
      appBar: null, // Remove the app bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF597E52), // Text color
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                    height: 20), // Space between name field and email field
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: 'First Name', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                  ),
                ),
                if (_firstNameError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _firstNameError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                    height: 20), // Space between name field and email field
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Last Name', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                  ),
                ),
                if (_lastNameError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _lastNameError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                    height: 20), // Space between name field and email field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                  ),
                ),
                if (_emailError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _emailError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                    height: 20), // Space between email field and password field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                  ),
                  obscureText: true,
                ),
                if (_passwordError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _passwordError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                    height:
                        20), // Space between password field and confirm password field
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password', // Placeholder text
                    hintStyle: TextStyle(
                        color: Color(0xFF597E52)), // Placeholder color
                  ),
                  obscureText: true,
                ),
                if (_confirmPasswordError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _confirmPasswordError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                    height:
                        20), // Space between confirm password field and sign up button
                SizedBox(
                  width: 180, // Set width of the button
                  child: ElevatedButton(
                    onPressed: _submitForm, // Call _signup method
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFFF1E4C3), // Button background color
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
        ),
      ),
    );
  }
}
