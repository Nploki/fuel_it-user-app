import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/screens/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
      child: Text("Sign-Out"),
      onPressed: () {
        FirebaseAuth.instance.signOut().then(
          (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => welcome_screen(),
              ),
            );
          },
        );
      },
    )));
  }
}
