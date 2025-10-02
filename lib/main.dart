import 'package:flutter/material.dart';
import 'screens/splashScreen.dart'; // LandingPage manages bottom nav and routing
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart';

void main() async {
  // 1. MUST BE CALLED FIRST
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Simple print for web debugging
    print("Firebase Initialization Error: $e");
  }
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
      routes: {...appRoutes},
    );
  }
}
