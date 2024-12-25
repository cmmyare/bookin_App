import 'package:booking/pages/auth/auth_page.dart'; // International flight provider
import 'package:booking/pages/local_model/LocalFlightProvider.dart'; // Local flight provider
import 'package:booking/pages/model/FlightSelectionProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              FlightSelectionProvider(), // International provider
        ),
        ChangeNotifierProvider(
          create: (context) => LocalFlightProvider(), // Local provider
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(), // Replace this with the actual landing page of your app
    );
  }
}
