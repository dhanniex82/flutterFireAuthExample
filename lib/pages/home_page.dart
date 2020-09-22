import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire2/services/firebase_repository.dart';

import '../pages/login_page.dart';
import '../models/project_list.dart';

final firebaseUserStream = StreamProvider(
    (ref) => FirebaseUserAuthChanges().stream.asBroadcastStream());

final projectStateNotifier = StateNotifierProvider((ref) => ProjectList());
final projectStreamProvider =
    StreamProvider((ref) => FirebaseRepo().getProject());

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = FirebaseAuth.instance.currentUser;
    final projects = watch(projectStateNotifier.state);
    final projectFromStream = watch(projectStreamProvider);
    /* User myUser;
    final firebaseUser = watch(firebaseUserStream);
    firebaseUser.when(
        data: (data) => myUser = data,
        loading: () => myUser = null,
        error: (e, s) => print(e.toString())); */

    return Scaffold(
      appBar: AppBar(
        title: Text(user.email ?? 'null'),
        leading: IconButton(
          icon: Icon(Icons.download_rounded),
          onPressed: () {
            context.read(projectStateNotifier).getAllProject();
            print(projects.length);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: projectFromStream.when(
                data: (data) {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final proj = data[index];
                        return Text(
                          proj.projectCode,
                          style: TextStyle(
                              color: index.isEven
                                  ? Colors.blue[600]
                                  : Colors.black),
                        );
                      });
                },
                loading: () => CircularProgressIndicator(),
                error: (e, s) => Text(e.toString()))),
      ),
    );
  }
}

class FirebaseUserAuthChanges {
  User user;
  FirebaseUserAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User u) {
      user = u;
      _controller.add(user);
    });
  }
  final _controller = StreamController<User>();
  Stream<User> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
