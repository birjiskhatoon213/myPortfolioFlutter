// landingPage.dart

import 'package:flutter/material.dart';
import 'package:birjis_khatoon/screens/downloads.dart';       // Home page content (Portfolio, images, button)
import 'package:birjis_khatoon/screens/projects.dart';   // Projects page
import 'package:birjis_khatoon/screens/skills.dart';     // Skills page
import 'package:birjis_khatoon/screens/contact.dart';    // Contact page
import 'package:birjis_khatoon/screens/mainScreen.dart'; // MainScreen page
import 'package:birjis_khatoon/screens/experience.dart'; //Experience page
import '../widgets/bottomNavBar.dart'; // Bottom navigation bar widget

// Define constants for the indices to improve readability
// Assuming the order is: MainScreen(0), Projects(1), Skills(2), Contact(3), Home(4)
const int mainScreenIndex = 0;
const int projectsIndex = 1;

// LandingPage manages bottom navigation and switching between pages
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = mainScreenIndex; // Tracks currently selected tab, set to MainScreen index

  // Method to change the active tab index, which will be passed to MainScreen
  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // List of pages for navigation.
  // NOTE: This list must be defined inside build or in init state
  // because MainScreen now needs the _setIndex method.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize the pages list, passing the callback to MainScreen
    _pages = [
      // Pass the index setter to MainScreen
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
      // IndexedStack shows only the page at _currentIndex
      // Keeps other pages alive in memory (state preserved)
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex, // Highlight active tab
        onTap: _setIndex, // Use the setIndex method for bottom nav taps
      ),
    );
  }
}