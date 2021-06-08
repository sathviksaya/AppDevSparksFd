import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<UserCredential> signInWithGoogle() async {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => signInWithGoogle(),
              icon: Icon(Icons.android),
              label: Text("SignIn With Google"),
            ),
          ],
        ),
      ),
    );
  }
}