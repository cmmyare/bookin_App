//import 'dart:math';

import 'package:booking/pages/auth/auth_page.dart';
//import 'package:booking/pages/auth/login.dart';
//import 'package:booking/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RightIcons extends StatefulWidget {
  const RightIcons({super.key});

  @override
  State<RightIcons> createState() => _RightIconsState();
}

class _RightIconsState extends State<RightIcons> {
  @override
  Widget build(BuildContext context) {
    bool showLoginPage = true;
    void togglePge() {
      setState(() {
        showLoginPage = !showLoginPage;
      });
    }

    void signOut() {
      setState(() {
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const AuthPage();
        }));
      });
    }

    onTap() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Notifications',
              style: TextStyle(
                color: Colors.blue[300],
              ),
            ),
            content: const Text('0 Notifications received'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.blue[300],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        // Notification icon
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.teal[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.teal.shade500,
                      spreadRadius: 2,
                      blurRadius: 10),
                ]),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.notification_add_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        // signout icon
        GestureDetector(
          onTap: signOut,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.teal[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.teal.shade300,
                      spreadRadius: 2,
                      blurRadius: 15),
                ]),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }
}
