//import 'dart:math';

import 'package:booking/components/buttonField.dart';
import 'package:booking/components/squereTile.dart';
import 'package:booking/components/textfield.dart';
import 'package:booking/pages/auth/forgetPassword.dart';
//import 'package:booking/pages/intro_page.dart';
//import 'package:booking/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;
  Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // sign in method
  void signUserIn() async {
    // loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usenameController.text, password: passController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // show error mesage
      ShowErrorMesssage(e.code);
    }
  }

  void ShowErrorMesssage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

// textfield controller
  final usenameController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                // logo
                Image.asset(
                  "lib/images/plane.png",
                  height: 110,
                ),
                const SizedBox(
                  height: 50,
                ),
                // welcome message
                Text(
                  "Welcom back you\'ve missed",
                  style: GoogleFonts.notoSerif(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // user name from textField in component folder
                MyFields(
                  controlller: usenameController,
                  hintText: "User name",
                  onscureText: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                // passwerd
                MyFields(
                  controlller: passController,
                  hintText: "Password",
                  onscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                // forget Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (contex) {
                            return Forgetpassword();
                          }));
                        },
                        child: Text(
                          "Forget Password",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //bottom
                MyButton(
                  // sign method at the top(signUserIn)
                  text: 'Sign In',
                  onTap: signUserIn,
                ),
                // other
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 3,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 3,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // google or apple sign in
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Squeretile(imagePath: 'lib/images/apple-logo.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    Squeretile(imagePath: 'lib/images/search.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    // Squeretile(imagePath: 'lib/images/facebook.png'),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // register new one
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have not account"),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
