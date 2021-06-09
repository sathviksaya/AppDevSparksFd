import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loadingScreen.dart';
import 'authScreen.dart';
import 'homeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'SignIn App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: snapshot.connectionState != ConnectionState.done
              ? Scaffold(
                  body: LoadingScreen(),
                )
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: LoadingScreen(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                          child: Text("Something Went Wrong!"),
                        ),
                      );
                    }
                    if (snapshot.data != null) {
                      return HomeScreen();
                    }
                    return AuthScreen();
                  },
                ),
        );
      },
    );
  }
}
