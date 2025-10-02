import 'package:flutter/material.dart';
// Imports the package for responsive grid layout
import 'package:responsive_grid_list/responsive_grid_list.dart';
// Imports the package to handle opening URLs
import 'package:url_launcher/url_launcher.dart';

// --- Data Structure for Contact Links ---
/// A simple data structure (model) to hold the details for each contact link.
class ContactLink {
  final String category, value, description, url;

  // Made const for efficiency
  const ContactLink({
    required this.category,
    required this.value,
    required this.description,
    required this.url,
  });
}

/// The main widget for the Contact screen.
class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

/// The State class associated with the [Contact] widget.
class _ContactState extends State<Contact> {
  // A final, constant list of [ContactLink] objects.
  final List<ContactLink> _contactLinks = const [
    ContactLink(
      category: 'E-MAIL',
      value: 'birjiskhatoon213@gmail.com',
      description: 'FOR PROJECT INQUIRIES',
      url: 'mailto:birjiskhatoon213@gmail.com',
    ),
    ContactLink(
      category: 'TELEGRAM',
      value: '@SWUETLANA',
      description: 'FOR PROJECT INQUIRY',
      url: 'https://t.me/SWUETLANA',
    ),
    ContactLink(
      category: 'BEHANCE',
      value: '@SWUETLANA',
      description: 'FOR DETAILED CASE STUDIES',
      url: 'https://www.behance.net/SWUETLANA',
    ),
    ContactLink(
      category: 'DRIBBBLE',
      value: '@SWUETLANA',
      description: 'FOR WORK IN PROGRESS',
      url: 'https://dribbble.com/SWUETLANA',
    ),
    ContactLink(
      category: 'INSTAGRAM',
      value: '@SWUETLANA.PROJECTS',
      description: 'FOR POST INSPIRATION',
      url: 'https://instagram.com/SWUETLANA.PROJECTS',
    ),
    ContactLink(
      category: 'LINKEDIN',
      value: 'Birjis Khatoon',
      description: 'FOR PROFESSIONAL INQUIRIES',
      url: 'https://linkedin.com/',
    ),
  ];

  // --- Launch URLs safely ---
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Show error message if the link cannot be opened
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open $url")),
      );
    }
  }

  // Contact Item Widget
  /// A private helper widget that builds the UI for a single contact link.
  Widget _contactItem(ContactLink link) {
    return Container(
      // Padding is applied to the content inside the grid cell
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centers the content horizontally.
        children: [
          // Category Text
          Text(
            link.category,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Tappable Link
          InkWell(
            onTap: () => _launchUrl(link.url),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Constrains the row's width to its children.
              children: [
                Flexible(
                  child: Text(
                    link.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // External link icon
                Icon(
                  Icons.call_made,
                  size: 14,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Description Text
          Text(
            link.description,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 1000;
            // Dynamic padding for the main screen content
            final double padding = isWide ? 80 : 20;

            // Left Section: The main heading and subheading.
            final leftSection = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'WANT TO DISCUSS\nA NEW PROJECT?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWide ? 48 : 36,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'CONTACT ME',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            );

            // Right Section: Using ResponsiveGridList for contact links.
            final rightSection = ResponsiveGridList(
              listViewBuilderOptions:  ListViewBuilderOptions(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Essential when nested in SingleChildScrollView
              ),
              // Links will arrange into columns when width allows at least 350px per item.
              minItemWidth: 350,
              horizontalGridSpacing: 40,
              verticalGridSpacing: 0,

              children: _contactLinks.map((link) {
                return _contactItem(link);
              }).toList(),
            );

            // Main layout structure.
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ConstrainedBox(
                  // Limits the overall width of the content on very large displays
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: isWide
                      ? Row(
                    // Wide Screen Layout: Side-by-side
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: leftSection),
                      const SizedBox(width: 60),
                      Expanded(child: rightSection),
                    ],
                  )
                      : Column(
                    // Narrow Screen Layout: Stacked vertically
                    children: [
                      // ADDED SPACE: Gives the heading breathing room from the top of the safe area.
                      const SizedBox(height: 20),
                      leftSection,
                      rightSection,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}