import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG images

// Home content page
class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownLoadsState();
}

class _DownLoadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(
      context,
    ).size.width; // Detect screen width
    const double maxContentWidth = 600.0; // Max width for large screens
    final double contentWidth = screenWidth > maxContentWidth
        ? maxContentWidth
        : screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SafeArea avoids notches and system overlays
        child: SingleChildScrollView(
          // Scrolls content if it overflows
          child: Center(
            // Center the content
            child: Container(
              width: contentWidth, // Restrict content width on tablets
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const PortfolioHeader(), // Header with icon and name
                  const SizedBox(height: 50),
                  Text(
                    "Innovate, Develop, Deploy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 400 ? 28 : 32, // Responsive font
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const StandardImage(), // First SVG image
                  const SizedBox(height: 20),
                  // const StandardImage(), // Second SVG image
                  const SizedBox(height: 40),
                  const ViewMyWorkBtn(), // Button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Portfolio Header ---
class PortfolioHeader extends StatelessWidget {
  const PortfolioHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              // color: Colors.black12,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(
              Icons.code,
              size: 40,
              color: const Color(0xFF6A9DFF),
            ),
          ),
          // const SizedBox(height: 10),
          const Text(
            'Birjis Khatoon', // Name
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(0xFF333333),
            ),
          ),
          const Text(
            'App Developer Portfolio', // Subtitle
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// --- Standard Image ---
class StandardImage extends StatelessWidget {
  const StandardImage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    double responsiveHeight = screenHeight * 0.28; // 28% of screen height
    const double maxImageHeight = 250.0; // Cap max height
    if (responsiveHeight > maxImageHeight) responsiveHeight = maxImageHeight;

    return Center(
      child: SvgPicture.asset(
        'images/landingPageGirl.svg',
        width: 300,
        height: responsiveHeight,
      ),
    );
  }
}

// --- View My Work Button ---
class ViewMyWorkBtn extends StatelessWidget {
  const ViewMyWorkBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('View My Work tapped!');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF6A9DFF), // Button color
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5, // Slight shadow
      ),
      child: const Text(
        'View My Work',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
