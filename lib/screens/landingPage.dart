// // landingPage.dart
//
// import 'package:flutter/material.dart';
// import 'package:birjis_khatoon/screens/downloads.dart'; // Home page content (Portfolio, images, button)
// import 'package:birjis_khatoon/screens/projects.dart'; // Projects page
// import 'package:birjis_khatoon/screens/skills.dart'; // Skills page
// import 'package:birjis_khatoon/screens/contact.dart'; // Contact page
// import 'package:birjis_khatoon/screens/mainScreen.dart'; // MainScreen page
// import 'package:birjis_khatoon/screens/experience.dart'; //Experience page
// import '../widgets/bottomNavBar.dart'; // Bottom navigation bar widget
//
// // Define constants for the indices to improve readability
// // Assuming the order is: MainScreen(0), Projects(1), Skills(2), Contact(3), Home(4)
// const int mainScreenIndex = 0;
// const int projectsIndex = 1;
//
// // LandingPage manages bottom navigation and switching between pages
// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});
//
//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }
//
// class _LandingPageState extends State<LandingPage> {
//   int _currentIndex =
//       mainScreenIndex; // Tracks currently selected tab, set to MainScreen index
//
//   // Method to change the active tab index, which will be passed to MainScreen
//   void _setIndex(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   // List of pages for navigation.
//   // NOTE: This list must be defined inside build or in init state
//   // because MainScreen now needs the _setIndex method.
//   late final List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the pages list, passing the callback to MainScreen
//     _pages = [
//       // Pass the index setter to MainScreen
//       MainScreen(onNavigate: _setIndex),
//       const Projects(),
//       const Skills(),
//       const Contact(),
//       const Experience(),
//       const Downloads(),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       // IndexedStack shows only the page at _currentIndex
//       // Keeps other pages alive in memory (state preserved)
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       // Custom bottom navigation bar
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _currentIndex, // Highlight active tab
//         onTap: _setIndex, // Use the setIndex method for bottom nav taps
//       ),
//       // body: Stack(
//       //   children: [
//       //     // ✅ Page content
//       //     IndexedStack(index: _currentIndex, children: _pages),
//       //     // ✅ Floating bottom navbar
//       //     Positioned(
//       //       bottom: 20, // safe margin from bottom
//       //       left: 0,
//       //       right: 0,
//       //       child: Center(
//       //         child: CustomBottomNavBar(
//       //           currentIndex: _currentIndex,
//       //           onTap: _setIndex,
//       //         ),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }

// landingPage.dart

import 'package:flutter/material.dart';
import 'package:birjis_khatoon/screens/downloads.dart';
import 'package:birjis_khatoon/screens/projects.dart';
import 'package:birjis_khatoon/screens/skills.dart';
import 'package:birjis_khatoon/screens/contact.dart';
import 'package:birjis_khatoon/screens/mainScreen.dart';
import 'package:birjis_khatoon/screens/experience.dart';
import '../widgets/bottomNavBar.dart'; // Custom bottom navigation bar widget

// Define constants for the indices to improve readability
const int mainScreenIndex = 0;
const int projectsIndex = 1;

// Define a maximum width for web/desktop viewing to prevent "zoomed" look.
const double _kMaxWebWidth = 810.0;

// LandingPage manages bottom navigation and switching between pages
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = mainScreenIndex;

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MainScreen(onNavigate: _setIndex),
      const Projects(),
      const Skills(),
      const Contact(),
      const Experience(),
      const Downloads(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 1. BODY: Constrained and Centered for web/desktop
      body: Center(
        child: ConstrainedBox(
          // Limits the width of the body content
          constraints: const BoxConstraints(maxWidth: _kMaxWebWidth),
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
      ),

      // 2. BOTTOM NAV BAR: Place at the bottom, and constrain its internal content.
      bottomNavigationBar: Container(
        // The container spans the full width of the screen on web,
        // but the content inside will be constrained.
        // child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxWebWidth),
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _setIndex,
            ),
          ),
        // ),
      ),
    );
  }
}
