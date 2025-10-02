// mainScreen.dart

import 'package:flutter/material.dart';
// Note: You must add this dependency to your pubspec.yaml:
// responsive_grid_list: ^1.4.1
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

// Entry point of the app
class MainScreen extends StatefulWidget {
  // 1. Add a callback function to the MainScreen widget
  final Function(int)? onNavigate;

  const MainScreen({super.key, required this.onNavigate});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// Main screen state
class _MainScreenState extends State<MainScreen> {
  // Helper method to determine the horizontal margin based on screen width
  double _getMargin(double width) {
    if (width < 800) {
      return 0; // No extra margin on small screens
    } else if (width < 1200) {
      return 80; // Moderate margin
    } else {
      return 120; // Larger margin for centering on large screens
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalMargin = _getMargin(screenWidth);

    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the screen
      body: SafeArea(
        // Ensures content is not behind status bar or notch
        child: SingleChildScrollView(
          // Makes the screen scrollable in case of overflow
          child: Container(
            // Apply responsive horizontal margin
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ), // Adds padding around the entire content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Main heading
                const Text(
                  "Hello, Everyone!",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ), // Spacing between heading and subheading
                // Subheading
                const Text(
                  "Welcome to my Portfolio.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 30), // Spacing before IntroBox

                // IntroBox fetches data from Firestore
                const IntroBox(),

                const SizedBox(height: 30), // Spacing before portfolio sections
                // 2. Pass the callback down to PortfolioSections
                PortfolioSections(onCardTap: widget.onNavigate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ***************************************************************
// START: DATA-DRIVEN INTRO BOX
// ***************************************************************

class IntroBox extends StatefulWidget {
  const IntroBox({super.key});

  @override
  State<IntroBox> createState() => _IntroBoxState();
}

class _IntroBoxState extends State<IntroBox> {
  // Correct Firestore path based on the uploaded image
  // Collection: 'birjisInfo'
  // Document ID: 'birjisInfo'
  final DocumentReference profileDoc = FirebaseFirestore.instance
      .collection('birjisInfo')
      .doc('birjisInfo');

  // Async function to fetch the document data once
  Future<Map<String, dynamic>?> _fetchProfileData() async {
    try {
      DocumentSnapshot snapshot = await profileDoc.get();
      if (snapshot.exists) {
        // Cast data to the expected type and return it
        return snapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error fetching profile data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder to handle the asynchronous data fetching
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchProfileData(),
      builder: (context, snapshot) {
        // Handle connection states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(30.0),
            child: CircularProgressIndicator(),
          ));
        }

        // Get the data map. If snapshot.data is null, use an empty map for safety.
        final Map<String, dynamic> data = snapshot.data ?? {};

        // Extract fields using the keys from your Firestore data
        final String profileName = data['name'] as String? ?? 'Loading Name...';
        final String designation = data['role'] as String? ?? 'Loading Role...';
        // Note: Using 'profileImageUrl' key from one of the fields in the DB image.
        // Fallback to a local asset if the field is missing or the image is not network-based.
        final String imageUrl = data['profileImageUrl'] as String? ?? 'images/placeholder.JPG';
        final String introduction = data['introduction'] as String? ??
            "Data is currently loading or unavailable. Please check the database connection.";

        // Determine the correct ImageProvider (NetworkImage or AssetImage)
        final bool isNetworkImage = imageUrl.isNotEmpty && imageUrl.startsWith('http');
        final ImageProvider profileImage = isNetworkImage
            ? NetworkImage(imageUrl) as ImageProvider
            : AssetImage(imageUrl) as ImageProvider;

        // Build the UI using the fetched data
        return Center(
          // Centers the container horizontally
          child: Container(
            width: double.infinity, // Container takes full width of the parent
            padding: const EdgeInsets.all(20.0), // Padding inside the container
            decoration: BoxDecoration(
              color: Colors.white, // Container background color
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                  spreadRadius: 2, // How much the shadow spreads
                  blurRadius: 8, // Blur effect for shadow
                  offset: const Offset(0, 4), // Shadow position (x, y)
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
              children: [
                // Row containing profile image and name/designation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image (Fixed Width: 100)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Circular image
                        image: DecorationImage(
                          image: profileImage, // Use the dynamic image provider
                          fit: BoxFit.cover, // Cover entire circle
                        ),
                      ),
                    ),
                    const SizedBox(width: 20), // Space between image and text (Fixed Width: 20)

                    // The Expanded widget ensures the text column uses the remaining space
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ), // Align text vertically with image
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name: Using fetched profileName
                            Text(
                              profileName,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8), // Space between name and designation
                            // Designation: Using fetched designation
                            Text(
                              designation,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey, // Lighter color for designation
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ), // Space between profile row and introduction heading
                // Introduction Heading
                const Text(
                  "Introduction",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), // Space between heading and paragraph
                // Paragraph describing the person: Using fetched introduction
                Text(
                  introduction,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    height: 1.5, // Line height for readability
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ***************************************************************
// END: DATA-DRIVEN INTRO BOX
// ***************************************************************


// Widget for responsive portfolio sections (No changes needed here)
class PortfolioSections extends StatelessWidget {
  // 3. Define the callback
  final Function(int)? onCardTap;

  const PortfolioSections({super.key, required this.onCardTap});

  // Data for the portfolio sections
  final List<Map<String, dynamic>> sections = const [
    {
      "title": "Projects",
      "icon": Icons.folder_open,
      "color": Colors.blue,
      "navIndex": 1,
    },
    {
      "title": "Skills",
      "icon": Icons.star,
      "color": Colors.orange,
      "navIndex": 2,
    },
    {
      "title": "Contact",
      "icon": Icons.mail,
      "color": Colors.green,
      "navIndex": 3,
    },
    {
      "title": "Experience",
      "icon": Icons.work,
      "color": Colors.teal,
      "navIndex": 4,
    }, // Placeholder
    {
      "title": "Downloads",
      "icon": Icons.download,
      "color": Colors.purple,
      "navIndex": 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // --- KEY CHANGE: Using ResponsiveGridList ---
    return ResponsiveGridList(
      // Configuration for how the list behaves inside a SingleChildScrollView
      listViewBuilderOptions:  ListViewBuilderOptions(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
      // The key to responsiveness: defines the minimum width of a card.
      // If the screen can fit two cards of this size, it will show 2 columns, etc.
      minItemWidth: 300,

      horizontalGridSpacing: 20, // Horizontal spacing between cards
      verticalGridSpacing: 20, // Vertical spacing between rows

      // Map the data list to a list of widgets
      children: sections.map((section) {
        // 4. Wrap the card with a GestureDetector
        return GestureDetector(
          onTap: () {
            final index = section["navIndex"] as int;
            if (onCardTap != null) {
              // 5. Call the callback function with the card's index (1 for Projects)
              onCardTap!(index);
            }
          },
          // The content of the card itself
          child: Container(
            // width property is no longer needed as ResponsiveGridList handles sizing
            padding: const EdgeInsets.all(20.0), // Padding inside each card
            decoration: BoxDecoration(
              color: Colors.white, // Card background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Subtle shadow
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
              children: [
                Icon(
                  section["icon"],
                  size: 40,
                  color: section["color"],
                ), // Icon for the section
                const SizedBox(height: 10), // Space between icon and title
                Text(
                  section["title"], // Section title
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ), // Space between title and description
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Phasellus vehicula justo eget diam posuere sollicitudin.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4, // Line height for readability
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}