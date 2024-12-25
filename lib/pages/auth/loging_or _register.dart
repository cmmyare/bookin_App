import 'package:booking/pages/auth/login.dart';
import 'package:booking/pages/auth/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrREgister extends StatefulWidget {
  const LoginOrREgister({super.key});

  @override
  State<LoginOrREgister> createState() => _LoginOrREgisterState();
}

class _LoginOrREgisterState extends State<LoginOrREgister> {
  // initialy show login page
  bool showLoginPage = true;
  void togglePge() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePge,
      );
    } else {
      return RegisterPage(
        onTap: togglePge,
      );
    }
  }
}
