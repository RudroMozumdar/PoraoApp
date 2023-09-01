import 'package:flutter/material.dart';
import 'package:porao_app/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              user?.email ?? 'User Email',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Auth().signOut();
              },
              child: const Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
