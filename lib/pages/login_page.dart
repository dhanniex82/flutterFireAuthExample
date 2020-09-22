import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_auth_service.dart';
import '../pages/home_page.dart';

final firebaseUserChangeNotifier = ChangeNotifierProvider<FirebaseAuthService>(
    (ref) => FirebaseAuthService(FirebaseAuth.instance));

final loadingState = StateProvider((ref) => false);

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String errorMessage = '🤔';
    final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
    final _emailTextController = TextEditingController();
    final _passwordTextController = TextEditingController();
    bool isLoading = watch(loadingState).state;

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _loginFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailTextController,
                  decoration: InputDecoration(labelText: 'email'),
                  validator: (String value) =>
                      _formFiledValidation(value, "email"),
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordTextController,
                  decoration: InputDecoration(labelText: 'password'),
                  validator: (String value) =>
                      _formFiledValidation(value, 'password'),
                ),
                FlatButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'login',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onPressed: () async {
                    if (_loginFormKey.currentState.validate())
                      context.read(loadingState).state = true;
                    await context
                        .read(firebaseUserChangeNotifier)
                        .signInWithEmailAndPassword(
                            _emailTextController.text.trim(),
                            _passwordTextController.text.trim())
                        .then((User user) {
                      if (user != null) {
                        context.read(loadingState).state = false;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      } else
                        return;
                    }).catchError((error) {
                      errorMessage = error.toString();
                      print(errorMessage);
                    });
                  },
                ),
                Text(errorMessage),
                isLoading ? CircularProgressIndicator() : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//TODO: RegEx form field validation
String _formFiledValidation(String value, String field) {
  if (value.isEmpty) {
    return "$field cannot be empty";
  }
  return null;
}
