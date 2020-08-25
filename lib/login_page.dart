import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isValid;
  GlobalKey<FormState> _loginFormKey;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;

  @override
  void initState() {
    _isValid = false;
    _loginFormKey = GlobalKey<FormState>();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _loginFormKey,
          autovalidate: _isValid,
          child: Column(
            children: [
              TextFormField(
                controller: _emailTextController,
                decoration: InputDecoration(labelText: 'email'),
                validator: (String value) =>
                    _formFiledValidation(value, "email"),
              ),
              TextFormField(
                controller: _passwordTextController,
                decoration: InputDecoration(labelText: 'password'),
                validator: (String value) =>
                    _formFiledValidation(value, 'password'),
              ),
              FlatButton(
                child: Text('login'),
                onPressed: () async {
                  setState(() {
                    _isValid = true;
                  });
                  if (_loginFormKey.currentState.validate())
                    try {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .whenComplete(
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            ),
                          );
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      print(e.message);
                    }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formFiledValidation(String value, String field) {
  if (value.isEmpty) {
    return "$field cannot be empty";
  }
  return null;
}
