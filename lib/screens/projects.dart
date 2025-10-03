// projects.dart (Native Solution - Full Screen Responsive)

// Core Flutter material design library. (UI Part)
import 'package:flutter/material.dart';
// REQUIRED for Riverpod state management. This is the core of the Integration part.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// UI Part: Enables dynamic arrangement of project cards based on screen size.
import 'package:responsive_grid_list/responsive_grid_list.dart';
// UI Logic/Part: Used to style multiple specific words/phrases within a single string (for ProjectMainDescription).
import 'package:easy_rich_text/easy_rich_text.dart';

// Import the Project model definition. (Logic/Data Part)
import '../models/projectsList_data.dart';
// Import the Project fetching logic and the Riverpod provider. (Integration/API Part)
import '../repository/projectsList_repository.dart';

// ===========================================
// MAIN SCREEN WIDGET - Converted to ConsumerWidget
// ===========================================

// Defines the main Projects screen widget, inheriting from ConsumerStatefulWidget to use Riverpod. (Integration/UI Part)
class Projects extends ConsumerStatefulWidget {
  // Constructor for the Projects widget.
  const Projects({super.key});

  @override
  // Creates the mutable state for this widget, using ConsumerState for Riverpod access. (Integration Part)
  ConsumerState<Projects> createState() => _ProjectsState();
}

// The state class for the Projects screen, extending ConsumerState. (Integration/Logic Part)
class _ProjectsState extends ConsumerState<Projects> {
  // The state class for the Projects screen.

  // Helper method to determine the horizontal margin based on screen width. (UI Logic)
  double _getMargin(double width) {
    // Logic: If screen is small (mobile size).
    if (width < 800) {
      return 0; // No margin on smaller screens.
      // Logic: If screen is medium (tablet size).
    } else if (width < 1200) {
      return width * 0.1; // 10% margin on tablets.
      // Logic: If screen is large (desktop size).
    } else {
      return width * 0.15; // 15% margin on large screens.
    }
  }

  @override
  // The method responsible for building the UI. (UI Part)
  Widget build(BuildContext context) {
    // UI Logic: Gets current screen width for responsive calculations.
    double screenWidth = MediaQuery.of(context).size.width;

    // 1. WATCH THE RIVERPOD PROVIDER (Integration/API Call)
    // This line fetches the data (loading, error, or data) from Firestore via Riverpod.
    // It triggers the API call automatically and causes a rebuild when the state changes.
    final projectsAsyncValue = ref.watch(projectsFutureProvider);

    return Scaffold(
      // Provides the basic screen structure. (UI Part)
      backgroundColor: Colors.white,
      body: SafeArea(
        // UI Part: Ensures content respects system overlays (e.g., notches, status bars).
        child: SingleChildScrollView(
          // UI Part: Allows the content to scroll vertically.
          child: Container(
            // Apply responsive horizontal margin using the helper method. (UI Logic/Part)
            margin: EdgeInsets.symmetric(horizontal: _getMargin(screenWidth)),
            child: Column(
              // Main vertical layout for the screen content. (UI Part)
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align content to the left.
              children: <Widget>[
                const SizedBox(height: 100), // Top spacing. (UI Part)
                const ProjectMainDescription(), // Widget displaying the introductory text. (UI Part)
                const SizedBox(
                  height: 100,
                ), // Spacing between text and cards. (UI Part)
                // 2. HANDLE THE ASYNC STATES using the .when() method (Integration/UI Logic)
                projectsAsyncValue.when(
                  // State 1: Data is successfully loaded (AsyncValue.data)
                  data: (projectsList) {
                    // Logic: Check if the fetched list is empty.
                    if (projectsList.isEmpty) {
                      // UI Part: Show a fallback message if no projects were found.
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: Text(
                            'No projects found in Firestore.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }
                    // UI Part: Pass the fetched list of Project objects to the display widget.
                    return ProjectCards(projects: projectsList);
                  },

                  // State 2: Error occurred during fetching (AsyncValue.error)
                  error: (err, stack) => Center(
                    // UI Part: Display an error message to the user.
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        // Display a user-friendly error message.
                        'Error loading projects. Please check connection and logs.',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // State 3: Data is currently loading (AsyncValue.loading)
                  loading: () => const Center(
                    // UI Part: Show a loading spinner.
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

                const SizedBox(height: 50), // Bottom spacing. (UI Part)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================
// PROJECT MAIN DESCRIPTION WIDGET (UNMODIFIED)
// ===========================================
// Stateless widget for static text content. (UI Part)
class ProjectMainDescription extends StatelessWidget {
  const ProjectMainDescription({super.key});

  // Logic/Data: The complete, unstyled block of text.
  static const String fullText =
      "I develop applications based on exact requirements, carefully handling all possible scenarios. I deliver solutions efficiently while maintaining high-quality standards, follow timelines strictly, and ensure the code is clean, maintainable, and scalable. I focus on building apps that perform well, are easy to extend, and provide real value to users, while collaborating effectively with teams to ship features that work in the real world.";

  // UI Part: Default style for the text.
  static const TextStyle _baseStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: Colors.black,
  );

  // UI Part: Style used for highlighted/bold phrases.
  static const TextStyle _boldStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    // Logic: List of phrases that need to be bolded.
    final List<String> boldPhrases = [
      'exact requirements',
      'carefully handling all possible scenarios',
      'deliver solutions efficiently',
      'high-quality standards',
      'follow timelines strictly',
      'clean',
      'maintainable',
      'scalable',
      'perform well',
      'easy to extend',
      'real value',
      'collaborating effectively',
      'ship features',
      'work in the real world',
    ];

    // Logic: Converts the list of phrases into a single regular expression pattern.
    String targetPattern = boldPhrases
        .map((phrase) {
          // Logic: Escapes special characters within the phrase for regex safety.
          String escapedPhrase = phrase.replaceAllMapped(
            RegExp(r'([.+*?^$(){}|[\]\\])'),
            (match) => r'\' + match.group(0)!,
          );
          // Logic: Wraps each escaped phrase in parentheses for grouping in the final regex.
          return '($escapedPhrase)';
        })
        .join(
          '|',
        ); // Logic: Joins all phrases with '|' (OR operator) to match any of them.

    // UI Part: Adds horizontal padding to the rich text.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // UI Part: Widget from the easy_rich_text package to apply multiple styles.
      child: EasyRichText(
        fullText, // The source text.
        defaultStyle: _baseStyle, // Default styling for all text.
        patternList: [
          // List of patterns to apply specific styling.
          EasyRichTextPattern(
            targetString: targetPattern, // The generated regex pattern.
            style: _boldStyle, // Applies the bold style to the matched phrases.
            matchWordBoundaries:
                false, // Allows matching partial/internal strings.
          ),
        ],
      ),
    );
  }
}

// ===========================================
// PROJECT CARDS WIDGET - Modified to accept data
// ===========================================
// Stateless widget for the grid display. (UI Part)
class ProjectCards extends StatelessWidget {
  // ADD: A required field to receive the dynamically fetched project list. (Integration/Data Part)
  final List<Project> projects;

  // Constructor requires the list of projects to be passed in.
  const ProjectCards({super.key, required this.projects});

  // Helper method to create a single Card widget from a Project object. (UI/Logic Part)
  Widget _buildProjectCard(BuildContext context, Project project) {
    // The InkWell wraps the entire card area and makes it tappable. (UI Part)
    return InkWell(
      onTap: () {
        // UI Logic: Navigates to the details page using the route fetched from Firestore.
        Navigator.pushNamed(context, project.detailsRoute);
      },
      child: Container(
        // Container for the card's visual styling (background, rounded corners, shadow). (UI Part)
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // Column stacks the Image and Text content. (UI Part)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Image Section
            Flexible(
              // Allows the image section to take vertical space proportionally.
              flex: 5,
              child: ClipRRect(
                // Clips the image to match the container's rounded top corners. (UI Part)
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: AspectRatio(
                  // Ensures the image maintains a 16:9 aspect ratio. (UI Part)
                  aspectRatio: 16 / 9,
                  // Widget for loading images from the network. (UI Part)
                  child: Image.network(
                    project
                        .imageUrl, // Uses the fetched imageUrl property from the Project model. (Data Part)
                    fit: BoxFit
                        .cover, // Ensures the image fills the aspect ratio box.
                    // Custom builder to show load progress. (UI Part)
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null)
                        return child; // Displays the image when loading is complete.
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            // Calculates progress value (0.0 to 1.0).
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null, // Indeterminate progress if total bytes is unknown.
                          ),
                        ),
                      );
                    },
                    // Custom builder for error state (e.g., broken URL). (UI Part)
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons
                                .broken_image, // Shows a fallback icon on load failure.
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 2. Project Name and Description Section (Text Content)
            Flexible(
              flex: 0, // Less weight for the text content.
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding around the text.
                child: Column(
                  // Vertical stack for title and description.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Ensures content-based height.
                  children: <Widget>[
                    // Project Name (Title)
                    Text(
                      project.title, // Uses fetched title. (Data Part)
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2, // Limits the title to two lines.
                      overflow: TextOverflow
                          .ellipsis, // Truncates with "..." if text exceeds maxLines.
                    ),
                    const SizedBox(height: 8),

                    // Project Description
                    Text(
                      project
                          .description, // Uses fetched description. (Data Part)
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                      maxLines: 5, // Limit description height.
                      overflow: TextOverflow.ellipsis, // Truncates description.
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UI Part: Adds horizontal padding around the grid itself.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // UI Part: The main grid layout widget from the external package.
      child: ResponsiveGridList(
        // Optimization options for the internal ListView. (UI Logic)
        listViewBuilderOptions:  ListViewBuilderOptions(
          shrinkWrap:
              true, // Optimizes vertical space usage (takes only required space).
          physics:
              NeverScrollableScrollPhysics(), // Prevents nested scrolling conflict with SingleChildScrollView.
        ),
        // Defines the minimum width of an item for wrapping. (UI Logic)
        minItemWidth: 350,
        // Defines the spacing between the cards horizontally.
        horizontalGridSpacing: 25,
        // Defines the spacing between the cards vertically.
        verticalGridSpacing: 25,
        // Generates the list of project cards by mapping the dynamically loaded list. (Logic)
        children: projects.map((project) {
          // Calls the helper method to build each card widget using the Project object.
          return _buildProjectCard(context, project);
        }).toList(), // Converts the iterable map result to a List<Widget>.
      ),
    );
  }
}
