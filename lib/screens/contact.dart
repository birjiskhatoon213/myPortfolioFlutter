import 'package:flutter/material.dart'; // Imports the core Flutter material design library. UI Part.
// Imports the package for responsive grid layout
import 'package:responsive_grid_list/responsive_grid_list.dart'; // UI Part: Enables dynamic arrangement of contact cards.
// Imports the package to handle opening URLs
import 'package:url_launcher/url_launcher.dart'; // Integration Part: Essential for opening external links (mail, web, social).

// --- Data Structure for Contact Links ---
/// A simple data structure (model) to hold the details for each contact link. // Documentation: Describes the purpose of the model class.
class ContactLink {
  // Defines the ContactLink class. Logic Part.
  final String category,
      value,
      description,
      url; // Data fields for link details and destination.

  // Made const for efficiency // Logic Part: Making the constructor constant improves performance with static data.
  const ContactLink({
    required this.category, // Required field for the link's type (e.g., 'E-MAIL').
    required this.value, // Required field for the display text (e.g., 'birjiskhatoon213@gmail.com').
    required this.description, // Required field for the subtitle text.
    required this.url, // Required field for the actual URL/URI to launch.
  });
}

/// The main widget for the Contact screen. // Documentation: Describes the main widget.
class Contact extends StatefulWidget {
  // UI Part: Defines the screen widget.
  const Contact({super.key}); // Constructor.

  @override
  State<Contact> createState() => _ContactState(); // Creates the state object.
}

/// The State class associated with the [Contact] widget.
class _ContactState extends State<Contact> {
  // The mutable state for the Contact screen.
  // A final, constant list of [ContactLink] objects. // Logic Part: Stores the static data displayed on the screen.
  final List<ContactLink> _contactLinks = const [
    // Declared as const to ensure immutability and compile-time optimization.
    ContactLink(
      // Data for the Email link.
      category: 'E-MAIL',
      value: 'birjiskhatoon213@gmail.com',
      description: 'FOR PROJECT INQUIRIES',
      url:
          'mailto:birjiskhatoon213@gmail.com', // Integration Part: Uses the 'mailto:' scheme.
    ),
    ContactLink(
      // Data for the Telegram link.
      category: 'TELEGRAM',
      value: '@SWUETLANA',
      description: 'FOR PROJECT INQUIRY',
      url: 'https://t.me/SWUETLANA', // Integration Part: Telegram web link.
    ),
    ContactLink(
      // Data for the Behance link.
      category: 'BEHANCE',
      value: '@SWUETLANA',
      description: 'FOR DETAILED CASE STUDIES',
      url:
          'https://www.behance.net/SWUETLANA', // Integration Part: Behance web link.
    ),
    ContactLink(
      // Data for the Dribbble link.
      category: 'DRIBBBLE',
      value: '@SWUETLANA',
      description: 'FOR WORK IN PROGRESS',
      url:
          'https://dribbble.com/SWUETLANA', // Integration Part: Dribbble web link.
    ),
    ContactLink(
      // Data for the Instagram link.
      category: 'INSTAGRAM',
      value: '@SWUETLANA.PROJECTS',
      description: 'FOR POST INSPIRATION',
      url:
          'https://instagram.com/SWUETLANA.PROJECTS', // Integration Part: Instagram web link.
    ),
    ContactLink(
      // Data for the LinkedIn link.
      category: 'LINKEDIN',
      value: 'Birjis Khatoon',
      description: 'FOR PROFESSIONAL INQUIRIES',
      url: 'https://linkedin.com/', // Integration Part: LinkedIn web link.
    ),
  ];

  // --- Launch URLs safely ---
  Future<void> _launchUrl(String url) async {
    // Integration Logic: Defines the method to open external links.
    final uri = Uri.parse(
      url,
    ); // Integration Part: Parses the URL string into a Uri object.

    if (await canLaunchUrl(uri)) {
      // Integration Part: Safely checks if the operating system can handle the URL scheme (e.g., 'mailto:', 'https:').
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      ); // Integration Part: Opens the URL using the external default application.
    } else {
      // Show error message if the link cannot be opened
      ScaffoldMessenger.of(context).showSnackBar(
        // UI Part: Displays a temporary message (SnackBar) to the user.
        SnackBar(
          content: Text("Could not open $url"),
        ), // Provides feedback on the failure.
      );
    }
  }

  // Contact Item Widget
  /// A private helper widget that builds the UI for a single contact link. // Documentation: Describes the UI component for one link.
  Widget _contactItem(ContactLink link) {
    // Takes a single ContactLink object as data.
    return Container(
      // Wrapper container for styling and padding.
      // Padding is applied to the content inside the grid cell
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ), // Vertical padding for spacing between grid items.
      child: Column(
        // Arranges the category, value, and description vertically.
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centers the content horizontally.
        children: [
          // Category Text
          Text(
            link.category, // Displays the link type (e.g., 'E-MAIL').
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              letterSpacing: 1.5, // Adds spacing between letters.
            ),
            textAlign: TextAlign.center,
          ),

          // Tappable Link
          InkWell(
            // UI Part: Makes the text responsive to touch with a ripple effect.
            onTap: () => _launchUrl(
              link.url,
            ), // Integration Part: Calls the launch method when tapped.
            child: Row(
              // Row to hold the value text and the external link icon.
              mainAxisSize: MainAxisSize
                  .min, // Constrains the row's width to its children.
              children: [
                Flexible(
                  // Allows the text to shrink if necessary within the row.
                  child: Text(
                    link.value, // Displays the address/username.
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      decoration: TextDecoration
                          .underline, // Adds an underline to suggest it's a link.
                    ),
                  ),
                ),
                const SizedBox(width: 4), // Small horizontal space.
                // External link icon
                Icon(
                  Icons
                      .call_made, // Icon commonly used for external links/navigation.
                  size: 14,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Description Text
          Text(
            link.description, // Displays the context/purpose (e.g., 'FOR PROJECT INQUIRIES').
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Builds the main screen UI.
    return Scaffold(
      // Provides the basic screen structure.
      backgroundColor: const Color(
        0xFFFAFAFA,
      ), // Sets a light gray background color.
      body: SafeArea(
        // Ensures content is below the status bar/notch.
        child: LayoutBuilder(
          // UI Logic: Dynamically adjusts layout based on the available width.
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth >
                1000; // UI Logic: Defines a breakpoint for switching between row/column layouts.
            // Dynamic padding for the main screen content
            final double padding = isWide
                ? 80
                : 20; // UI Logic: Applies larger padding on wide screens.

            // Left Section: The main heading and subheading.
            final leftSection = Column(
              // Container for the main promotional text.
              mainAxisSize: MainAxisSize
                  .min, // Allows the column to take minimum vertical space.
              children: [
                Text(
                  'WANT TO DISCUSS\nA NEW PROJECT?',
                  textAlign: TextAlign.center, // Centers the heading text.
                  style: TextStyle(
                    fontSize: isWide
                        ? 48
                        : 36, // UI Logic: Adjusts font size based on screen width.
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'CONTACT ME', // Subheading text.
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ), // Space before the right/bottom section.
              ],
            );

            // Right Section: Using ResponsiveGridList for contact links.
            final rightSection = ResponsiveGridList(
              // UI Part: Creates the dynamic grid of contact links.
              listViewBuilderOptions: ListViewBuilderOptions(
                shrinkWrap:
                    true, // Makes the list view only take the space required by its children.
                physics:
                    NeverScrollableScrollPhysics(), // Essential when nested in SingleChildScrollView to prevent scroll conflict.
              ),
              // Links will arrange into columns when width allows at least 350px per item.
              minItemWidth:
                  350, // UI Logic: Defines the width threshold for column wrapping.
              horizontalGridSpacing: 40, // Horizontal space between grid items.
              verticalGridSpacing:
                  0, // Vertical space between grid rows (minimal, as padding is in _contactItem).

              children: _contactLinks.map((link) {
                // Maps the static data list to the _contactItem widget.
                return _contactItem(link);
              }).toList(),
            );

            // Main layout structure.
            return Center(
              // Centers the entire scrollable content horizontally.
              child: SingleChildScrollView(
                // Allows the entire screen content to scroll.
                padding: EdgeInsets.all(
                  padding,
                ), // Applies the dynamic overall padding.
                child: ConstrainedBox(
                  // UI Logic: Ensures the content doesn't get excessively wide on huge monitors.
                  // Limits the overall width of the content on very large displays
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: isWide
                      ? Row(
                          // Wide Screen Layout: Uses a Row for side-by-side content.
                          // Wide Screen Layout: Side-by-side
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: leftSection,
                            ), // Allows the heading to take proportional space.
                            const SizedBox(
                              width: 60,
                            ), // Horizontal spacing between the two main sections.
                            Expanded(
                              child: rightSection,
                            ), // Allows the grid to take proportional space.
                          ],
                        )
                      : Column(
                          // Narrow Screen Layout: Uses a Column for stacked vertical content.
                          // Narrow Screen Layout: Stacked vertically
                          children: [
                            // ADDED SPACE: Gives the heading breathing room from the top of the safe area.
                            const SizedBox(
                              height: 20,
                            ), // Adds initial space for better visual balance.
                            leftSection, // Displays the heading section.
                            rightSection, // Displays the contact links grid below the heading.
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
