import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgenceTile extends StatelessWidget {
  String title;
  String subtile;
  AgenceTile({super.key, required this.title, required this.subtile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.tealAccent),
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.notoSerif(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(subtile),
            trailing: const Icon(Icons.delete),
          )),
    );
  }
}
