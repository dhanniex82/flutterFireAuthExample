import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('user sign in: ');
        print(user.email);
      }
    });
    return Scaffold(
      body: Center(
        child: Text('welcome'),
      ),
    );
  }
}
