import 'package:flutter/material.dart';
import 'screens/splashScreen.dart'; // LandingPage manages bottom nav and routing

void main() {
  // runApp is the entry point of a Flutter app
  runApp(const MyApp());
}

// MyApp is the root widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp provides material design styling
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        // primarySwatch: Colors.blue, // Sets default app colors
        fontFamily: 'Poppins', // Global font
      ),
      home: const SplashScreen(), // First screen to show
    );
  }
}

