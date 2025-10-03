import 'package:flutter/material.dart'; // Imports the core Flutter material design library. UI Part.
import 'package:birjis_khatoon/screens/landingPage.dart'; // Imports the next screen to navigate to after the splash delay. Integration Part.

class SplashScreen extends StatefulWidget {
  // Defines the splash screen widget. UI Part.
  const SplashScreen({super.key}); // Constructor.

  @override
  State<SplashScreen> createState() => _SplashScreenState(); // Creates the mutable state.
}

class _SplashScreenState extends State<SplashScreen> {
  // The state class managing the splash screen logic.
  @override
  void initState() {
    // Called exactly once when the widget is created. Logic Part.
    super.initState();
    // Wait for 2-3 seconds and navigate to LandingPage
    Future.delayed(const Duration(seconds: 2), () {
      // Logic Part: Schedules a function to run after a delay (2 seconds).
      Navigator.pushReplacement(
        // Integration Part: Navigates to the new screen and removes the current screen from the navigation stack.
        context,
        MaterialPageRoute(
          builder: (context) => const LandingPage(),
        ), // Integration Part: Defines the target screen (LandingPage).
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Builds the visual layout of the splash screen. UI Part.
    return Scaffold(
      // Provides the basic screen structure.
      backgroundColor: Colors
          .white, // Splash screen background // UI Part: Sets a solid white background.
      body: Center(
        // Centers the content vertically and horizontally.
        child: Column(
          // Arranges the logo and text vertically.
          mainAxisAlignment: MainAxisAlignment
              .center, // Centers children in the vertical space.
          children: [
            // Logo
            Icon(
              // Displays a material icon as a logo placeholder. UI Part.
              Icons.code,
              size: 80,
              color: const Color(
                0xFF6A9DFF,
              ), // Sets a specific blue color for the icon.
            ),
            const SizedBox(
              height: 20,
            ), // Vertical spacing between icon and text.
            // App Name
            const Text(
              // Displays the app/profile name. UI Part.
              'Birjis Khatoon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(
                  0xFF333333,
                ), // Sets a dark gray color for the text.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
