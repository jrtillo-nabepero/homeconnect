import 'package:flutter/material.dart';
import 'package:tes2_project/components/my_button.dart';
import 'package:tes2_project/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:tes2_project/globals.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showError = false;
  bool passwordVisible=true;
  Future<void> signIn() async {
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(Uri.parse(urlLoginPage));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      for (var map in data) {
        final username = map['username'];
        final password = map['password'];
        final id = map['id'];
        if (username == usernameController.text && password == passwordController.text) {
          globalVariable = id;
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          return; // Exit the function after successful login
        }
      }
      Navigator.pop(context);
      // If the loop finishes without finding matching credentials, set showError to true
      setState(() {
        debugPrint("error");
        showError = true;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (your other code remains the same)

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 35),
              Image.asset(
                'images/logo.png',
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 35),

              const Text(
                "Welcome to HomeConnect!",
                style: TextStyle(color: Colors.blueAccent,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Your arduino based home automation system",
                style: TextStyle(color: Colors.blue,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              MyTextField(
                controller: usernameController,
                prefixIcon: const Icon(Icons.person),
                hintText: 'Username',
                obscureText: false,
                errorText: showError ? 'Invalid username or password' : null,
              ),

              const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: passwordController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  errorText: showError ? 'Invalid username or password' : null, // Display error text if provided
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  labelText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                            () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

              const SizedBox(height: 25),

              MyButton(
                onTap: signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
