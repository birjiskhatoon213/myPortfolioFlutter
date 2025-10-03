// landingPage.dart

import 'package:flutter/material.dart'; // Core Flutter material design library. UI Part.
import 'package:birjis_khatoon/screens/downloads.dart'; // Imports the Downloads screen. UI Part.
import 'package:birjis_khatoon/screens/projects.dart'; // Imports the Projects screen. UI Part.
import 'package:birjis_khatoon/screens/skills.dart'; // Imports the Skills screen. UI Part.
import 'package:birjis_khatoon/screens/contact.dart'; // Imports the Contact screen. UI Part.
import 'package:birjis_khatoon/screens/mainScreen.dart'; // Imports the MainScreen (Home/Landing). UI Part.
import 'package:birjis_khatoon/screens/experience.dart'; // Imports the Experience screen. UI Part.
import '../widgets/bottomNavBar.dart'; // Imports the custom bottom navigation bar widget. UI Part.

// Define constants for the indices to improve readability
const int mainScreenIndex = 0; // Logic Part: Index 0 corresponds to MainScreen.
const int projectsIndex = 1; // Logic Part: Index 1 corresponds to Projects.

// Define a maximum width for web/desktop viewing to prevent "zoomed" look.
// const double _kMaxWebWidth = 810.0; // Commented out constant for maximum web width.

// LandingPage manages bottom navigation and switching between pages // Documentation: Describes the widget's role as the primary screen manager.
class LandingPage extends StatefulWidget {
  // UI Part: StatefulWidget because it manages the active screen index.
  const LandingPage({super.key}); // Constructor.

  @override
  State<LandingPage> createState() => _LandingPageState(); // Creates the state object.
}

class _LandingPageState extends State<LandingPage> {
  // The mutable state class.
  int _currentIndex =
      mainScreenIndex; // State: Tracks the currently selected tab index, initialized to MainScreen (0).

  void _setIndex(int index) {
    // Logic Part: Callback function passed down to children (NavBar and MainScreen cards).
    setState(() {
      // Triggers a rebuild of the widget tree.
      _currentIndex = index; // Updates the active index.
    });
  }

  late final List<Widget>
  _pages; // State: Declared as late to be initialized in initState.

  @override
  void initState() {
    // Initializes the state when the widget is first created.
    super.initState();
    _pages = [
      // List of all navigable pages.
      MainScreen(
        onNavigate: _setIndex,
      ), // UI/Integration Part: Home screen, passes the navigation callback to its cards.
      const Projects(), // UI Part: Projects screen.
      const Skills(), // UI Part: Skills screen.
      const Contact(), // UI Part: Contact screen.
      const Experience(), // UI Part: Experience screen.
      const Downloads(), // UI Part: Downloads screen.
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Builds the main structure of the application.
    return Scaffold(
      // Provides the basic app structure (body and bottomNavigationBar).
      backgroundColor: Colors.white, // Sets the default background color.
      // 1. BODY: Constrained and Centered for web/desktop
      body: Center(
        // Centers the content horizontally, typically for web/desktop layouts.
        child: ConstrainedBox(
          // UI Logic: Limits the size of the content area.
          // Limits the width of the body content
          constraints:
              const BoxConstraints(), // Placeholder constraints (could be used to limit max width).
          child: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ), // UI Part: Shows the widget corresponding to _currentIndex, preserving state of others.
        ),
      ),

      // 2. BOTTOM NAV BAR: Place at the bottom, and constrain its internal content.
      bottomNavigationBar: Container(
        // Container to hold the bottom navigation bar.
        // The container spans the full width of the screen on web,
        // but the content inside will be constrained.
        // child: Center( // Commented out Center wrapper.
        child: ConstrainedBox(
          // UI Logic: Limits the internal content size of the nav bar, often matching the body width.
          constraints: const BoxConstraints(), // Placeholder constraints.
          child: CustomBottomNavBar(
            // UI Part: The custom navigation bar widget.
            currentIndex:
                _currentIndex, // Passes the active index to highlight the correct tab.
            onTap:
                _setIndex, // Passes the callback function to handle tab taps.
          ),
        ),
        // ), // Commented out Center closing.
      ),
    );
  }
}
