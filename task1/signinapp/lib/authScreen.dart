import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void signInWithGoogle() async {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    // Future<UserCredential> signInWithFacebook() async {
    //   final AccessToken result =
    //       (await FacebookAuth.instance.login()) as AccessToken;
    //   final facebookAuthCredential =
    //       FacebookAuthProvider.credential(result.token);
    //   return await FirebaseAuth.instance
    //       .signInWithCredential(facebookAuthCredential);
    // }

    void signInWithGitHub() async {
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
          clientId: "960671727d16cd29f754",
          clientSecret: "596d40c1dc1722267c05f04a9145aeaf97a9a0ee",
          redirectUrl:
              'https://signinapp-6f430.firebaseapp.com/__/auth/handler');
      final result = await gitHubSignIn.signIn(context);
      final githubAuthCredential = GithubAuthProvider.credential(result.token);
      try {
        await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("SignIn App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login With...",
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () => signInWithGoogle(),
              icon: Image.asset(
                "assets/google.png",
                height: 20,
              ),
              label: Text("SignIn With Google"),
            ),
            // ElevatedButton.icon(
            //   onPressed: () => signInWithFacebook(),
            //   icon: Icon(Icons.facebook),
            //   label: Text("SignIn With Facebook"),
            // ),
            ElevatedButton.icon(
              onPressed: () => signInWithGitHub(),
              icon: Image.asset(
                "assets/github.png",
                height: 20,
              ),
              label: Text("SignIn With GitHub"),
            ),
          ],
        ),
      ),
    );
  }
}
