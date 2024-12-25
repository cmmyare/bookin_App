//import 'package:booking/pages/Home.dart';
import 'package:booking/pages/nav_pages/intro_page.dart';
//import 'package:booking/pages/login.dart';
import 'package:booking/pages/auth/loging_or%20_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // is login
          if (snapshot.hasData) {
            return IntroPage();
          }
          // not loging
          else {
            return LoginOrREgister();
          }
        },
      ),
    );
  }
}
