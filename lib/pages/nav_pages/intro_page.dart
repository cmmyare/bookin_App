import 'package:booking/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.only(
                  left: 80.0, right: 80, top: 130, bottom: 25),
              child: Image.asset("lib/images/plane.png"),
            ),
            // Main Text
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Life is a journey enjoy the flight",
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Sub Text
            Text(
              "LET'S GO AND EXPLORE ✈",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 50),
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const HomePage();
                })),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Start",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50), // Extra space at the bottom
          ],
        ),
      ),
    );
  }
}
