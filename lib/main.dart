// lib/main.dart

import 'package:flutter/material.dart'; // Imports the core Flutter material design library. UI Part.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod // Integration Part: Imports Riverpod for state management.
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core // Integration Part: Imports Firebase initialization utility.
import 'firebase_options.dart'; // Assuming you still need Firebase for other features // Integration Part: Imports platform-specific Firebase configuration file.
import 'screens/splashScreen.dart'; // Integration Part: Imports the initial screen widget.
import 'routes.dart'; // Integration Part: Imports the map of named routes.

// Make main function asynchronous
void main() async {
  // Main entry point of the Flutter application. Logic/Integration Part.
  // 1. MUST BE CALLED FIRST: Ensures Flutter is initialized before anything else
  WidgetsFlutterBinding.ensureInitialized(); // Logic/Integration Part: Ensures all engine bindings are loaded before running async initialization.

  // 2. Initialize Firebase (Keep this block if you plan to use Firebase Auth/Storage/etc. later)
  try {
    // Standard practice for handling potential errors during initialization.
    // If you are ONLY using a Node.js API, you can comment this block out.
    // However, it's safer to leave it if 'firebase_core' is in your pubspec.yaml.
    await Firebase.initializeApp(
      // Integration Part: Initializes the Firebase app instance.
      options: DefaultFirebaseOptions
          .currentPlatform, // Uses the configuration specific to the running platform (iOS, Android, Web, etc.).
    );
  } catch (e) {
    print(
      "Firebase Initialization Error: $e",
    ); // Logic Part: Prints an error message if Firebase fails to initialize.
  }

  // 3. Wrap the root widget with ProviderScope to enable Riverpod
  runApp(
    const ProviderScope(child: MyApp()),
  ); // Integration Part: Starts the Flutter app, wrapping MyApp in ProviderScope to enable Riverpod access.
}

// MyApp is the root widget
class MyApp extends StatelessWidget {
  // Defines the root widget of the application. UI Part.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The top-level widget providing core features like navigation and themes.
      debugShowCheckedModeBanner:
          false, // UI Part: Removes the debug banner in the top-right corner.
      theme: ThemeData(
        fontFamily: 'Poppins',
      ), // UI Part: Sets the global theme, specifically the default font family.
      home:
          const SplashScreen(), // First screen to show // UI Part: Sets the initial screen that appears on launch.
      routes: {
        ...appRoutes,
      }, // Integration Part: Registers the named routes defined in `routes.dart`.
    );
  }
}

// **NOTE:** The ProfileData model and Repository code should be in their own files (see below).
