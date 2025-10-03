// lib/screens/mainScreen.dart

import 'package:flutter/material.dart'; // Core Flutter material design library. UI Part.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod state management library. Integration Part.
import 'package:responsive_grid_list/responsive_grid_list.dart'; // Third-party package for responsive grids. UI Part.
// Import your service and model from their respective files
import '../repository/profile_repository.dart'; // Imports the data layer (Firestore fetching) provider. Integration Part.
import '../models/profile_data.dart'; // Imports the structured data models (ProfileData, SectionData). Logic Part.

// =========================================================================
// UTILITY: Icon String to IconData Converter
// =========================================================================

/// Converts the string representation of an icon (e.g., 'Icons.folder_open') // Documentation: Explains the function's purpose.
/// stored in Firestore back into a usable Flutter [IconData] object. // Logic Part: The stored data is a string, but the UI needs an IconData object.
IconData stringToIconData(String iconName) {
  // Function definition that takes the string name.
  // A simple switch statement maps the known string names to the actual IconData constants. // Logic Part: Maps string data to Flutter enum constants.
  switch (iconName) {
    case 'Icons.folder_open': // Checks for the specific string value from Firestore.
      return Icons.folder_open; // Returns the actual Flutter IconData object.
    case 'Icons.star': // Checks for star icons.
    case 'Icons.star_border': // Checks for star border icons (using the same star icon for simplicity).
      return Icons.star; // Returns the star IconData.
    case 'Icons.mail': // Checks for mail icon.
      return Icons.mail; // Returns the mail IconData.
    case 'Icons.work': // Checks for work icon.
      return Icons.work; // Returns the work IconData.
    case 'Icons.download': // Checks for download icon.
      return Icons.download; // Returns the download IconData.
    default: // Fallback case if the string from Firestore doesn't match known icons.
      return Icons
          .error; // Fallback icon for unrecognized strings. UI/Logic Part.
  }
}

// =========================================================================
// MAIN SCREEN
// =========================================================================

/// The main entry screen for the portfolio. // Documentation: Describes the widget's role.
class MainScreen extends StatefulWidget {
  // UI Part: StatefulWidget because it holds the onNavigate function needed by children.
  /// The callback function used to navigate when a nav item (or card) is tapped. // Integration Part: This function comes from the parent widget (likely Scaffold with BottomNavBar).
  final Function(int)? onNavigate; // Defines the navigation function signature.
  const MainScreen({
    super.key,
    required this.onNavigate,
  }); // Constructor requiring the navigation callback.

  @override
  State<MainScreen> createState() => _MainScreenState(); // Creates the mutable state for this widget.
}

class _MainScreenState extends State<MainScreen> {
  // The state class for MainScreen.
  /// Helper method to calculate responsive horizontal margin based on screen width. // UI Logic: Ensures content is centered and readable on large screens.
  double _getMargin(double width) {
    if (width < 800) return 0; // Small screens get no margin.
    if (width < 1200) return 80; // Medium screens get 80 margin.
    return 120; // Large screens get 120 margin.
  }

  @override
  Widget build(BuildContext context) {
    // Builds the primary layout of the screen.
    double screenWidth = MediaQuery.of(
      context,
    ).size.width; // UI Logic: Gets current screen width for responsiveness.
    double horizontalMargin = _getMargin(
      screenWidth,
    ); // UI Logic: Calculates the dynamic margin.

    return Scaffold(
      // Provides the basic material structure (appBar, body, etc.). UI Part.
      backgroundColor: Colors.white, // Sets the entire background to white.
      body: SafeArea(
        // Ensures content avoids device cutouts (notch, status bar). UI Part.
        child: SingleChildScrollView(
          // Allows the content to be scrollable if it exceeds screen height. UI Part.
          child: Container(
            // Container for applying the responsive horizontal margin.
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
            ), // Applies dynamic margin.
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ), // Inner padding for the content.
            child: Column(
              // Main vertical layout structure for the screen content. UI Part.
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns all children to the start (left).
              children: <Widget>[
                // Static Headers
                const Text(
                  // Standard welcome text. UI Part.
                  "Hello, Everyone!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8), // Vertical spacing.
                const Text(
                  // Standard subtitle text.
                  "Welcome to my Portfolio.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ), // Vertical spacing before data content.
                // Pass the navigation function down
                ProfileContentLoader(
                  onNavigate: widget.onNavigate,
                ), // Integration Part: Instantiates the data handler, passing the navigation callback.
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// PROFILE CONTENT LOADER (Riverpod State Handler)
// =========================================================================

/// [ProfileContentLoader] is a [ConsumerWidget] that watches the asynchronous // Integration Part: Uses Riverpod's ConsumerWidget to listen to state changes.
/// [profileDataProvider] state and determines which UI to display (Loading, Error, or Data). // Integration Part: This is the core data fetching state handler.
class ProfileContentLoader extends ConsumerWidget {
  /// The function to call when a card needs to navigate. // Integration Part: Receives the navigation function from MainScreen.
  final Function(int)? onNavigate;
  const ProfileContentLoader({
    super.key,
    required this.onNavigate,
  }); // Constructor requiring the navigation callback.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build method that provides access to the WidgetRef (Riverpod).
    // Watch the FutureProvider. This widget rebuilds when the state changes. // Integration Part: Listens to the asynchronous data provider.
    final profileDataAsyncValue = ref.watch(
      profileDataProvider,
    ); // Reads the current state (AsyncValue: Loading, Error, or Data).

    // Use the .when() method for clean, structured state handling. // Integration Logic: Riverpod's pattern for handling async states elegantly.
    return profileDataAsyncValue.when(
      // State: LOADING - Show a loading spinner while Firestore request is in progress.
      loading: () => const Center(
        // UI Part: Displays a spinner while fetching data.
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      ),
      // State: ERROR - Show a specific error message if data fetch fails.
      error: (error, stack) => Center(
        // UI Part: Displays an error message if the fetch failed.
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Error Loading Profile: ${error.toString()}', // Displays the error details.
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // State: DATA - Success! Build the profile box and the section cards.
      data: (data) {
        // Data is the successfully retrieved ProfileData object.
        return Column(
          // Container for the main content when data is available.
          children: [
            // Pass the fetched data to the introduction box widget
            RiverpodIntroBox(
              data: data,
            ), // UI Part: Displays static profile details.
            const SizedBox(height: 30), // Vertical spacing.
            // Pass the fetched section data AND the navigation function to the card grid widget
            PortfolioSections(
              // UI Part: Displays the dynamic grid of cards.
              sections: data.sections, // Passes the section data map.
              onNavigate:
                  onNavigate, // Integration Part: Passes the navigation callback down.
            ),
          ],
        );
      },
    );
  }
}

// =========================================================================
// INTRODUCTION BOX WIDGET
// =========================================================================

/// [RiverpodIntroBox] displays the main profile picture, name, role, and introduction. // Documentation: Describes the widget's function.
/// It receives the required data via its constructor. // UI Part: A stateless widget that only renders the data it receives.
class RiverpodIntroBox extends StatelessWidget {
  final ProfileData data; // The required, non-null profile data.
  const RiverpodIntroBox({super.key, required this.data}); // Constructor.

  @override
  Widget build(BuildContext context) {
    // Determine the image source (network or local asset fallback) // Logic Part: Checks if the image URL is valid for network fetching.
    final bool isNetworkImage =
        data.imageUrl.isNotEmpty && data.imageUrl.startsWith('http');
    final ImageProvider profileImage =
        isNetworkImage // Selects the correct image provider.
        ? NetworkImage(data.imageUrl)
              as ImageProvider // Uses NetworkImage if a valid URL exists.
        : const AssetImage('images/placeholder.JPG')
              as ImageProvider; // Uses a local asset as a fallback.

    return Center(
      // Centers the content horizontally.
      child: Container(
        width: double
            .infinity, // Makes the container take the full available width.
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          // Styling for the intro box.
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            // Applies a shadow for a raised effect.
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Rest of the UI structure for image and text)
            Row(
              // Layout for the image and name/role text side-by-side.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // Container for the circular profile image.
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Makes the container circular.
                    image: DecorationImage(
                      image:
                          profileImage, // Uses the dynamically chosen image source.
                      fit: BoxFit.cover, // Ensures the image fills the circle.
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  // Allows the text column to fill the remaining horizontal space.
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      // Column for name and role.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name, // Fetched data: Displays the profile name.
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.role, // Fetched data: Displays the profile role.
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              // Section title "Introduction".
              "Introduction",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.introduction, // Fetched data: Displays the introduction text.
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// PORTFOLIO SECTIONS WIDGET (Dynamic Cards)
// =========================================================================

/// [PortfolioSections] builds the responsive grid of portfolio cards using data // Documentation: Describes the widget's purpose.
/// sourced from the Firestore document via the [sections] map.
class PortfolioSections extends StatelessWidget {
  /// The dynamic map of section data passed from the Riverpod state. // Logic Part: The raw data from the model.
  final Map<String, SectionData> sections;

  /// The function to call when a card needs to navigate. // Integration Part: The navigation callback.
  final Function(int)? onNavigate;

  const PortfolioSections({
    super.key,
    required this.sections,
    this.onNavigate,
  }); // Constructor.

  /// Defines the display order and colors for the cards. The 'key' must match // Logic Part: Hardcoded list to define UI presentation order and styling.
  /// the keys used in the Firestore 'sections' map ('projects', 'skills', etc.).
  final List<Map<String, dynamic>> sectionOrder = const [
    {
      "key": "projects",
      "color": Colors.blue,
      "navIndex": 1,
    }, // Associates Firestore key with UI properties and Nav Index.
    {"key": "skills", "color": Colors.orange, "navIndex": 2},
    {"key": "contact", "color": Colors.green, "navIndex": 3},
    {"key": "experience", "color": Colors.teal, "navIndex": 4},
    {"key": "downloads", "color": Colors.purple, "navIndex": 5},
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Map the fixed order list to dynamic card widgets // Logic Part: Iterates over the defined order to build the grid widgets.
    final List<Widget> cardWidgets = sectionOrder
        .where((orderItem) {
          // Safety check: Only build a card if the data for its key exists. // Logic Part: Ensures the app doesn't crash if a section is missing in Firestore.
          return sections.containsKey(orderItem['key']);
        })
        .map((orderItem) {
          final String key = orderItem['key'] as String;
          final SectionData data =
              sections[key]!; // Gets the specific SectionData object using the key.
          final Color color = orderItem['color'] as Color;
          final int navIndex =
              orderItem['navIndex'] as int; // Retrieves the navigation index.

          return GestureDetector(
            // Makes the entire card tappable. UI Part.
            onTap: () {
              // Action when the card is tapped.
              // *** EXECUTE NAVIGATION LOGIC HERE ***
              if (onNavigate != null) {
                // Checks if the navigation function was provided.
                onNavigate!(
                  navIndex,
                ); // Integration Part: Executes the navigation callback, changing the screen/nav bar state.
              }
              // ************************************
            },
            child: Container(
              // Visual container for the card.
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // Applies a shadow to the card.
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                // Vertical structure of the card content.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use the utility function to get the correct Icon
                  Icon(
                    stringToIconData(data.icon),
                    size: 40,
                    color: color,
                  ), // UI Part: Converts string to IconData and uses the predefined color.
                  const SizedBox(height: 10),
                  // Dynamic Title from Firestore
                  Text(
                    data.title, // Fetched data: Displays the section title.
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Dynamic Description from Firestore
                  Text(
                    data.description, // Fetched data: Displays the section description.
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        })
        .toList(); // Converts the mapped iterable to a List of Widgets.

    return ResponsiveGridList(
      // UI Part: Widget from the responsive_grid_list package.
      listViewBuilderOptions: ListViewBuilderOptions(
        // Configuration options for the underlying list view.
        shrinkWrap:
            true, // Allows the grid to only take up the necessary height.
        physics:
            NeverScrollableScrollPhysics(), // Prevents the grid itself from scrolling (parent SingleChildScrollView handles it).
      ),
      minItemWidth:
          300, // UI Logic: Defines the minimum width for each card before wrapping.
      horizontalGridSpacing: 20, // Spacing between cards horizontally.
      verticalGridSpacing: 20, // Spacing between cards vertically.
      children:
          cardWidgets, // The dynamic list of cards built from Firestore data.
    );
  }
}
