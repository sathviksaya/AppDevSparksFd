import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn App-Home"),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("LogOut",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome User"),
      ),
    );
  }
}
