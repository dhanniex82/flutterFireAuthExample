import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService extends ChangeNotifier {
  FirebaseAuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;
  User _user;

  Stream<User> firebaseUser = FirebaseAuth.instance.authStateChanges();

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        _user = userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
    }
    return _user;
  }
}
