// import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final usenameController = TextEditingController();
  @override
  void dispose() {
    usenameController.dispose();
    super.dispose();
  }

  Future ResetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: usenameController.text.trim());
      showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              content: Text('Reset Link sent you email.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Forget Password",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            "lib/images/plane.png",
            height: 110,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Enter your email, to get password reset link'),
          const SizedBox(
            height: 20,
          ),
          MyFields(
            controlller: usenameController,
            hintText: "Email",
            onscureText: false,
          ),
          const SizedBox(
            height: 15,
          ),
          MaterialButton(
            onPressed: () {
              ResetPassword();
            },
            child: Text("Reset Password"),
            color: Colors.blue[300],
          )
        ],
      ),
    );
  }
}
