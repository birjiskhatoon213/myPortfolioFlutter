import 'package:flutter/material.dart'; // UI: Imports core Flutter widgets and material design elements (Scaffold, AppBar, Column, etc.).
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Logic/UI: Imports Riverpod for state management and reactive programming (ConsumerWidget, ref.watch).
import 'package:responsive_grid_list/responsive_grid_list.dart'; // UI: Imports a third-party package for creating responsive, multi-column layouts easily.
import 'package:url_launcher/url_launcher.dart'; // Integration: Imports the package to handle opening external links (like the project website).

// --- CORRECTED IMPORTS --- // Logic: Comment indicating the corrected import section.
import '../../models/projectsList_data.dart'; // Logic: Imports the custom data models (KeyFeature, Skill, ProjectDetails) used by the UI.
import '../../repository/projectsList_repository.dart'; // Logic: Imports the Riverpod providers (specifically projectDetailsFutureProvider) from the repository.

// Placeholder for the project ID. Using 'project1' as default. // Logic: Comment explaining the constant's purpose.
const String _currentProjectId =
    'project1'; // Logic: Defines the hardcoded ID for the project whose details are being displayed.

// =========================================================================
// UTILITY & STYLES (Keep as is)
// =========================================================================

Future<void> _launchUrl(String url) async {
  // Integration/Logic: Function to safely launch an external URL.
  final uri = Uri.parse(
    url,
  ); // Logic: Converts the URL string into a Uri object, which is required by url_launcher.
  if (await canLaunchUrl(uri)) {
    // Integration/Logic: Checks if the device can handle the given URL scheme (e.g., http, https).
    await launchUrl(
      // Integration: Attempts to launch the URL.
      uri, // Integration: The URL to launch.
      mode: LaunchMode
          .externalApplication, // Integration: Specifies that the URL should open in an external application (like a web browser).
    );
  } else {
    // Logic: Executes if the URL cannot be launched.
    throw 'Could not launch $url'; // Logic: Throws an exception indicating the failure.
  }
}

class AppTextStyles {
  // UI: Defines a utility class to store consistent text styles for the entire screen.
  static const TextStyle sectionTitle = TextStyle(
    // UI: Style for main section headings.
    fontFamily: 'Poppins', // UI: Font family specification.
    fontSize: 22, // UI: Font size.
    fontWeight: FontWeight.w600, // UI: Font weight.
  );
  static const TextStyle descriptionBox = TextStyle(
    // UI: Style for the project description text.
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle featureHeading = TextStyle(
    // UI: Style for key feature titles.
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  static const TextStyle featureDescription = TextStyle(
    // UI: Style for key feature descriptions.
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
  static const TextStyle skillTitle = TextStyle(
    // UI: Style for skill names.
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle skillExperience = TextStyle(
    // UI: Style for skill experience text.
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
  static const TextStyle badgeText = TextStyle(
    // UI: Style for skill badge text.
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle buttonText = TextStyle(
    // UI: Style for the main button text.
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class SectionTitle extends StatelessWidget {
  // UI: A simple, reusable widget for consistent section titles.
  final String title; // UI: Field for the title text.
  const SectionTitle({
    super.key,
    required this.title,
  }); // UI: Constructor requiring the title.
  @override
  Widget build(BuildContext context) {
    // UI: Builds the widget.
    return Text(
      // UI: Displays the title.
      title, // UI: The title text.
      style: AppTextStyles
          .sectionTitle, // UI: Applies the predefined sectionTitle style.
    );
  }
}

// =========================================================================
// WIDGET 1: Project Description Section
// =========================================================================
class ProjectDescriptionSection extends StatelessWidget {
  // UI: Widget for displaying the long project description.
  final String
  description; // Logic/UI: Field to receive the full description text.
  const ProjectDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      // UI: Arranges children vertically.
      crossAxisAlignment:
          CrossAxisAlignment.start, // UI: Aligns content to the left.
      children: <Widget>[
        const SectionTitle(
          // UI: Displays the fixed title for this section.
          title: "Project Description",
        ),
        const SizedBox(height: 10), // UI: Vertical spacing.
        Container(
          // UI: A styled box for the description.
          width: double
              .infinity, // UI: Makes the container take the full available width.
          decoration: BoxDecoration(
            // UI: Applies color and rounded corners.
            color: Colors.lightBlue.shade50, // UI: Light blue background color.
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(
            16.0,
          ), // UI: Inner padding for the text.
          child: Text(
            // UI: Displays the description text.
            description, // UI: The description text passed to the widget.
            style: AppTextStyles
                .descriptionBox, // UI: Applies the predefined description box style.
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET 2: Screenshots Section
// =========================================================================
class ScreenshotSection extends StatelessWidget {
  // UI: Widget for displaying horizontal scrolling screenshots.
  final List<String>
  screenshotUrls; // Logic/UI: Field to receive a list of image URLs.
  const ScreenshotSection({super.key, required this.screenshotUrls});

  @override
  Widget build(BuildContext context) {
    if (screenshotUrls.isEmpty) {
      // Logic/UI: Checks if there are any URLs.
      return const SizedBox.shrink(); // UI: If empty, returns nothing to hide the section.
    }

    return Column(
      // UI: Arranges children vertically.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(
          title: "Screenshots",
        ), // UI: Displays the section title.
        const SizedBox(height: 10),
        Container(
          // UI: Container for the scrollable row.
          decoration: BoxDecoration(
            // UI: Styles the container with a background color.
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            // UI: Allows the content inside to be horizontally scrollable.
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              // UI: Lays out the screenshots horizontally.
              children: screenshotUrls.map(
                (url) {
                  // Logic/UI: Maps the list of URLs to a list of image widgets.
                  return Padding(
                    // UI: Adds spacing between images.
                    padding: const EdgeInsets.only(right: 18.0),
                    child: ClipRRect(
                      // UI: Clips the image to have rounded corners.
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        // UI: Displays the image fetched from the URL.
                        url, // Integration: The image URL.
                        width: 200,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          // UI: Fallback widget if the image fails to load.
                          width: 200, // UI: Placeholder width.
                          height: 250, // UI: Placeholder height.
                          color: Colors.grey.shade300,
                          child: const Center(child: Text('Image Error')),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(), // Logic: Converts the map iterable back into a List<Widget>.
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET 3A: KeyFeatureItem
// =========================================================================
class KeyFeatureItem extends StatelessWidget {
  // UI: Widget for a single key feature card.
  final KeyFeature
  feature; // Logic/UI: Field to receive a single KeyFeature model object.
  const KeyFeatureItem({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    final Color featureColor = feature
        .color; // Logic/UI: Extracts the color property for reuse in styling.

    return Container(
      // UI: The main card container.
      decoration: BoxDecoration(
        // UI: Styles the card with white background, rounded corners, and a subtle shadow.
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15.0),
      child: Row(
        // UI: Lays out the icon and text horizontally.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // UI: Container for the colored icon background.
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: featureColor.withOpacity(
                0.1,
              ), // UI: Uses a lighter tint of the feature color.
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              // UI: Displays the feature icon.
              feature.icon, // Logic/UI: The IconData from the KeyFeature model.
              color: featureColor, // UI: Uses the full feature color.
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            // UI: Ensures the text column takes the remaining space.
            child: Column(
              // UI: Lays out the heading and description vertically.
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  feature.heading,
                  style: AppTextStyles.featureHeading,
                ), // UI: Displays the heading.
                Text(
                  feature.description, // UI: Displays the description.
                  style: AppTextStyles.featureDescription,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET 3: Key Features Section
// =========================================================================
class KeyFeatureSection extends StatelessWidget {
  // UI: Widget that displays all KeyFeatureItems in a responsive grid.
  final List<KeyFeature>
  keyFeatureList; // Logic/UI: Field to receive the list of all KeyFeature models.
  const KeyFeatureSection({super.key, required this.keyFeatureList});

  @override
  Widget build(BuildContext context) {
    if (keyFeatureList.isEmpty) {
      // Logic/UI: Checks if the list is empty.
      return const SizedBox.shrink(); // UI: Hides the section if empty.
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(title: "Key Features"),
        const SizedBox(height: 10),
        ResponsiveGridList(
          // UI: The key component for the responsive layout.
          minItemWidth:
              320, // UI: Specifies the minimum width before wrapping items to the next line.
          listViewBuilderOptions:  ListViewBuilderOptions(
            // UI: Configuration for how the grid behaves.
            shrinkWrap:
                true, // UI: Makes the grid only take the space it needs (important inside a SingleChildScrollView).
            physics:
                NeverScrollableScrollPhysics(), // UI: Disables internal scrolling, deferring to the parent SingleChildScrollView.
          ),
          horizontalGridSpacing: 15, // UI: Spacing between columns.
          verticalGridSpacing: 15, // UI: Spacing between rows.
          children: keyFeatureList.map((feature) {
            // Logic/UI: Maps the list of models to the list of KeyFeatureItem widgets.
            return KeyFeatureItem(
              feature: feature,
            ); // UI: Creates an individual feature card.
          }).toList(),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET 4A: SkillItem
// =========================================================================
class SkillItem extends StatelessWidget {
  // UI: Widget for a single skill card.
  final Skill skill; // Logic/UI: Field to receive a single Skill model object.
  const SkillItem({super.key, required this.skill});

  Widget _buildBadge(String text, Color color) {
    // UI: Private helper function to create the colored text badge.
    return Container(
      // UI: Badge container.
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color, // UI: Uses the skill's specific badge color.
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        text.toUpperCase(), // UI: Displays the badge text in uppercase.
        style: AppTextStyles.badgeText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // UI: Main skill card container.
      decoration: BoxDecoration(
        // UI: Styles the container with a white background and a light gray border.
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Row(
        // UI: Main row layout for content (icon + text) and the badge.
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // UI: Pushes the content and badge to opposite sides.
        children: [
          Row(
            // UI: Inner row for the icon and text column.
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                // UI: Displays the skill icon.
                skill.icon, // Logic/UI: IconData from the Skill model.
                color: skill
                    .badgeColor, // UI: Uses the skill's badge color for the icon.
                size: 28,
              ),
              const SizedBox(width: 10),
              Column(
                // UI: Column for the skill title and experience.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.title,
                    style: AppTextStyles.skillTitle,
                  ), // UI: Displays the skill name.
                  Text(
                    skill.experience,
                    style: AppTextStyles.skillExperience,
                  ), // UI: Displays the experience text.
                ],
              ),
            ],
          ),
          _buildBadge(
            // UI: Calls the helper function to build the badge.
            skill.badgeText, // Logic/UI: Badge text from the model.
            skill.badgeColor, // Logic/UI: Badge color from the model.
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET 4: Skills Section
// =========================================================================
class SkillsSection extends StatelessWidget {
  // UI: Widget that displays all SkillItems in a responsive grid.
  final List<Skill>
  skillsUsedList; // Logic/UI: Field to receive the list of all Skill models.
  const SkillsSection({super.key, required this.skillsUsedList});

  @override
  Widget build(BuildContext context) {
    if (skillsUsedList.isEmpty) {
      // Logic/UI: Checks if the list is empty.
      return const SizedBox.shrink(); // UI: Hides the section if empty.
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(title: "Skills Used"),
        const SizedBox(height: 10),
        ResponsiveGridList(
          // UI: Grid for the skills.
          minItemWidth: 300,
          listViewBuilderOptions:  ListViewBuilderOptions(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          horizontalGridSpacing: 15,
          verticalGridSpacing: 15,
          children: skillsUsedList.map((skill) {
            // Logic/UI: Maps the list of models to the list of SkillItem widgets.
            return SkillItem(
              skill: skill,
            ); // UI: Creates an individual skill card.
          }).toList(),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET 5: Project Website Button
// =========================================================================
class ProjectWebsiteButton extends StatelessWidget {
  // UI: Widget for the main "Go to Website" button.
  final String
  projectUrl; // Logic/UI: Field to receive the external URL for the project.
  static const Color buttonColor = Color(
    0xFF9169F0,
  ); // UI: Fixed color for the button.

  const ProjectWebsiteButton({super.key, required this.projectUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // UI: Constrains the size of the button container.
      width: double.infinity, // UI: Makes the button full width.
      height: 55,
      child: ElevatedButton(
        // UI: The primary button widget.
        onPressed: () {
          // Logic/UI: Defines the action when the button is pressed.
          _launchUrl(
            // Integration/Logic: Calls the utility function to open the URL.
            projectUrl, // Integration: Passes the project URL.
          );
        },
        style: ElevatedButton.styleFrom(
          // UI: Styles the button.
          backgroundColor: buttonColor, // UI: Sets the background color.
          shape: RoundedRectangleBorder(
            // UI: Defines the shape (pill/rounded rectangle).
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 5, // UI: Adds a shadow/lift effect.
        ),
        child: const Text(
          // UI: The button text.
          'Go to Project Website',
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET 6: Main Screen (Project1)
// =========================================================================
class Project1 extends ConsumerWidget {
  // UI/Logic: The main screen widget, using ConsumerWidget to interact with Riverpod.
  const Project1({super.key});

  double _getHorizontalMargin(double width) {
    // Logic/UI: Helper function to determine horizontal padding based on screen width (responsiveness).
    if (width < 600) {
      // Logic: For small screens (mobile).
      return 20; // UI: Small padding.
    } else if (width < 1200) {
      // Logic: For medium screens (tablet/small desktop).
      return width * 0.05; // UI: 5% of width padding.
    } else {
      // Logic: For large screens (desktop).
      return width *
          0.15; // UI: 15% of width padding (creates a centered column).
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI/Logic: Build method, receives WidgetRef for Riverpod access.
    final screenWidth = MediaQuery.of(
      context,
    ).size.width; // UI: Gets the current screen width.
    final horizontalMargin = _getHorizontalMargin(
      screenWidth,
    ); // Logic/UI: Calculates the margin based on the width.

    // Watch the FutureProvider for project details // Logic: Comment explaining the Riverpod watch.
    final detailsAsyncValue = ref.watch(
      projectDetailsFutureProvider(_currentProjectId),
    ); // Logic: Watches the Family FutureProvider, passing the project ID. Returns an AsyncValue (data, loading, error).

    return Scaffold(
      // UI: The basic structure of the screen.
      appBar: AppBar(
        // UI: The top navigation bar.
        title: const Text(
          'Medcall UI/UX Case Study',
        ), // UI: Fixed title for the app bar.
        backgroundColor: const Color(
          0xFF9169F0,
        ), // UI: App bar background color.
        foregroundColor: Colors.white, // UI: Text/icon color on the app bar.
        shape: const RoundedRectangleBorder(
          // UI: Gives the app bar rounded corners at the bottom.
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: detailsAsyncValue.when(
        // Logic/UI: Handles the three states of the FutureProvider (loading, error, data).
        // 1. Loading State
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ), // UI: Displays a spinner while data is being fetched.
        // 2. Error State
        error: (err, stack) => Center(
          // UI: Displays an error message if the fetch fails.
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Error loading project details: ${err.toString()}', // Logic: Displays the error message.
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // 3. Data Loaded State
        data: (details) {
          // Logic: If data is successfully loaded, the 'details' object is available here.
          return SafeArea(
            // UI: Ensures content avoids system bars (notch, status bar).
            child: SingleChildScrollView(
              // UI: Allows the content to scroll vertically.
              child: Padding(
                // UI: Applies the calculated horizontal padding/margin.
                padding: EdgeInsets.only(
                  left: horizontalMargin,
                  right: horizontalMargin,
                  top: 20,
                  bottom: 40,
                ),
                child: Column(
                  // UI: The main content column.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 1. Project Description Section
                    ProjectDescriptionSection(
                      // UI: Renders the description section.
                      description: details
                          .fullDescription, // Logic/UI: Passes data from the model.
                    ),

                    const SizedBox(height: 30),

                    // 2. Screenshot Section
                    ScreenshotSection(
                      // UI: Renders the screenshot section.
                      screenshotUrls: details
                          .screenshotUrls, // Logic/UI: Passes data from the model.
                    ),

                    const SizedBox(height: 30),

                    // 3. Key Feature Section
                    KeyFeatureSection(
                      // UI: Renders the key features grid.
                      keyFeatureList: details
                          .keyFeatures, // Logic/UI: Passes data from the model.
                    ),

                    const SizedBox(height: 30),

                    // 4. Skills Section
                    SkillsSection(
                      // UI: Renders the skills grid.
                      skillsUsedList: details
                          .skillsUsed, // Logic/UI: Passes data from the model.
                    ),

                    const SizedBox(height: 40),

                    // 5. Project Website Button
                    ProjectWebsiteButton(
                      // UI: Renders the button.
                      projectUrl: details
                          .websiteUrl, // Logic/UI: Passes data from the model.
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
