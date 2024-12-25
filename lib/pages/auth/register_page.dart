import 'package:booking/components/buttonField.dart';
import 'package:booking/components/squereTile.dart';
import 'package:booking/components/textfield.dart';
//import 'package:booking/pages/intro_page.dart';
//import 'package:booking/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  void signUserUp() async {
    // loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      // check if pass and confirm are same
      if (passController.text == confirmController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usenameController.text, password: passController.text);
      } else {
        // pop up message
        Navigator.pop(context);
        // show error not matched
        ShowErrorMesssage("Password don't match!");
        return;
      }
      // pop up message
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

  final usenameController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();
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
                  "Welcom to flight booking app",
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
                  hintText: "Email",
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
                  height: 15,
                ),
                MyFields(
                  controlller: confirmController,
                  hintText: "Confirm",
                  onscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                //bottom
                MyButton(
                  // change this method you declered at top(signUserIn)
                  text: 'Sign Up',
                  onTap: signUserUp,
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
                    const Text("Already Have an Account"),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        child: const Text(
                          "Log In",
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
