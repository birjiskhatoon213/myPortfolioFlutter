// mainScreen.dart

import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the screen
      body: SafeArea(
        // Ensures content is not behind status bar or notch
        child: SingleChildScrollView(
          // Makes the screen scrollable in case of overflow
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth > 800 ? 120 : 0, // Only for large screens
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
                const IntroBox(), // Custom widget showing profile and introduction
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

// Widget for the profile and introduction section
class IntroBox extends StatelessWidget {
  const IntroBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centers the container horizontally
      child: Container(
        width: double.infinity, // Container takes full width of the parent
        // constraints: const BoxConstraints(maxWidth: 1000), // Optional max width for large screens
        padding: const EdgeInsets.all(20.0), // Padding inside the container
        decoration: BoxDecoration(
          color: Colors.white, // Container background color
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(
                0,
                0,
                0,
                0.2,
              ), // Shadow color with opacity
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 8, // Blur effect for shadow
              offset: const Offset(0, 4), // Shadow position (x, y)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to start
          children: [
            // Row containing profile image and name/designation
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Circular image
                    // NOTE: Ensure you have this image in your assets/images folder and pubspec.yaml
                    image: const DecorationImage(
                      image: AssetImage(
                        'images/birjisLP.JPG',
                      ), // Profile image from assets
                      fit: BoxFit.cover, // Cover entire circle
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Space between image and text
                // Name & Designation Column
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ), // Align text vertically with image
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Birjis Khatoon",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8), // Space between name and designation
                      Text(
                        "App Developer",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey, // Lighter color for designation
                        ),
                      ),
                    ],
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
            // Paragraph describing the person
            const Text(
              "I am a passionate Flutter developer with over 4 years of experience. "
              "I enjoy building beautiful and responsive mobile applications. "
              "My focus is on writing clean, maintainable code and following best practices. "
              "I am constantly learning new technologies and improving my skills. "
              "I am excited to contribute to innovative projects and collaborate with teams.",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                height: 1.5, // Line height for readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for responsive portfolio sections (Modified to handle tap)
class PortfolioSections extends StatelessWidget {
  // 3. Define the callback
  final Function(int)? onCardTap;

  const PortfolioSections({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    // List of portfolio cards with title, icon, color, AND NAV INDEX (Projects index is 1)
    final List<Map<String, dynamic>> sections = [
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
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the desired width based on the condition
    // final double widgetWidth = screenWidth > 800
    //     ? (screenWidth / 2) -
    //           160 // Half width on screens > 600, minus 160
    //     : double.infinity; // Full width on screens <= 600

    double getCardWidth(double width){
      if (width < 600){
        return double.infinity;
      }
      else if (width < 800){
          return (screenWidth/2) - 40;
      }
      else if (width < 1200){
         return (screenWidth/2) - 155;
      }
      else {
        return (screenWidth/3) - 110;
      }
    }
    return Wrap(
      spacing: 20, // Horizontal spacing between boxes
      runSpacing: 20, // Vertical spacing when boxes wrap to next line
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
          child: SizedBox(
            width: getCardWidth(screenWidth),
            child: Container(
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
          ),
        );
      }).toList(),
    );
  }
}
