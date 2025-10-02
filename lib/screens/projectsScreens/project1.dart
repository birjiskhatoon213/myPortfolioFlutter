import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
// Note: You must add url_launcher dependency to your pubspec.yaml
import 'package:url_launcher/url_launcher.dart';

// --- Utility Function for URL Launching ---
Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

// =========================================================================
// TEXT STYLES & REUSABLE WIDGETS
// =========================================================================

/// Centralized Text Styles for Headings and Body Content
class AppTextStyles {
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle descriptionBox = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle featureHeading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle featureDescription = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // Skill specific styles
  static const TextStyle skillTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle skillExperience = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static const TextStyle badgeText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Button text style
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// Reusable Widget for consistent section titles and spacing
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle,
    );
  }
}

// =========================================================================
// WIDGET 1: Project Description Section (StatelessWidget)
// =========================================================================
class ProjectDescriptionSection extends StatelessWidget {
  const ProjectDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(title: "Project Description"),
        const SizedBox(height: 10), // Space between title and box
        // The Project Description Box
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade50, // Background color
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            "Medcall a one-stop healthcare app in India. Book health check packages, schedule lab tests, consult with doctors virtually, and order medicines for same-day delivery, all in one place.",
            style: AppTextStyles.descriptionBox, // Reused style
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET 2: Screenshots Section (StatefulWidget)
// =========================================================================
const List<String> _screenshotUrls = [
  'https://picsum.photos/300/600?random=1',
  'https://picsum.photos/300/600?random=2',
  'https://picsum.photos/300/600?random=3',
  'https://picsum.photos/300/600?random=4',
  'https://picsum.photos/300/600?random=5',
  'https://picsum.photos/300/600?random=6',
  'https://picsum.photos/300/600?random=7',
  'https://picsum.photos/300/600?random=8',
];

class screenshotSection extends StatefulWidget {
  const screenshotSection({super.key});

  @override
  State<screenshotSection> createState() => _screenshotSectionState();
}

class _screenshotSectionState extends State<screenshotSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(title: "Screenshots"),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _screenshotUrls.map((url) {
                return Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      url,
                      width: 200,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// DATA: Feature List Map
// =========================================================================
const List<Map<String, dynamic>> keyFeatureList = [
  {
    'image': Icons.workspace_premium,
    'heading': 'Optimized User Flow',
    'description': 'Experience a seamless and intuitive navigation structure.',
    'color': Color(0xFF5C6BC0), // Blue/Indigo
  },
  {
    'image': Icons.integration_instructions,
    'heading': 'Extended Functionality',
    'description': 'Full support for custom integrations and external APIs.',
    'color': Color(0xFF5C6BC0),
  },
  {
    'image': Icons.check_circle,
    'heading': 'Efficient Validation',
    'description': 'Real-time form validation and error handling.',
    'color': Color(0xFF4DB6AC), // Teal/Green
  },
  {
    'image': Icons.task_alt,
    'heading': 'Scalable Architecture',
    'description': 'Built with a modular design to handle large user bases.',
    'color': Color(0xFF9575CD), // Light Purple
  },
  {
    'image': Icons.verified,
    'heading': 'Secure Deployments',
    'description': 'Utilizing modern security protocols and encryption.',
    'color': Color(0xFF4DB6AC),
  },
];

// =========================================================================
// WIDGET 3A: KeyFeatureItem (Reusable Widget for a Single Row)
// =========================================================================
class KeyFeatureItem extends StatelessWidget {
  final Map<String, dynamic> feature;

  const KeyFeatureItem({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    final Color featureColor = feature['color'] as Color;

    return Container(
      decoration: BoxDecoration(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: featureColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              feature['image'] as IconData,
              color: featureColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 15), // Spacer between icon and text
          // 2. Text Content (Heading and Description)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heading
                Text(
                  feature['heading'],
                  style: AppTextStyles.featureHeading,
                ),
                // Description
                Text(
                  feature['description'],
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
class keyfeatureSection extends StatefulWidget {
  const keyfeatureSection({super.key});

  @override
  State<keyfeatureSection> createState() => _keyfeatureSectionState();
}

class _keyfeatureSectionState extends State<keyfeatureSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(title: "Key Features"),
        const SizedBox(height: 10),

        // --- Responsive Grid for Features ---
        ResponsiveGridList(
          minItemWidth: 320,
          listViewBuilderOptions:  ListViewBuilderOptions(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          horizontalGridSpacing: 15,
          verticalGridSpacing: 15,

          children: keyFeatureList.map((feature) {
            return KeyFeatureItem(feature: feature);
          }).toList(),
        ),
      ],
    );
  }
}

// =========================================================================
// DATA: SKILLS USED LIST
// =========================================================================
const List<Map<String, dynamic>> skillsUsedList = [
  {
    'icon': Icons.data_usage,
    'title': 'React',
    'exp': '3 Years',
    'badgeText': 'Improved',
    'badgeColor': Color(0xFF64B5F6), // Light Blue
  },
  {
    'icon': Icons.storage,
    'title': 'SQL',
    'exp': '3 Years',
    'badgeText': 'Improved',
    'badgeColor': Color(0xFF64B5F6),
  },
  {
    'icon': Icons.devices_other,
    'title': 'Node.js',
    'exp': '3 Years',
    'badgeText': 'Learned',
    'badgeColor': Color(0xFFFFCC80), // Light Orange
  },
  {
    'icon': Icons.local_fire_department,
    'title': 'Firebase',
    'exp': '3 Years',
    'badgeText': 'Expert',
    'badgeColor': Color(0xFFFF8A65), // Light Red
  },
  {
    'icon': Icons.local_fire_department,
    'title': 'Firebase',
    'exp': '3 Years',
    'badgeText': 'Complete',
    'badgeColor': Color(0xFF81C784), // Light Green
  },
  {
    'icon': Icons.terminal,
    'title': 'TypeScript',
    'exp': '3 Years',
    'badgeText': 'Concept',
    'badgeColor': Color(0xFF9575CD), // Light Purple
  },
];

// =========================================================================
// WIDGET 4A: SkillItem (Reusable Widget for a Single Skill Card)
// =========================================================================
class SkillItem extends StatelessWidget {
  final Map<String, dynamic> skill;

  const SkillItem({super.key, required this.skill});

  // A small badge like "Improved" or "Expert"
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.badgeText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Icon and Text (Left side)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                skill['icon'] as IconData,
                color: skill['badgeColor'] as Color, // Use the badge color for the icon
                size: 28,
              ),
              const SizedBox(width: 10),
              // Text Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (e.g., React, Node.js)
                  Text(
                    skill['title'],
                    style: AppTextStyles.skillTitle,
                  ),
                  // Experience (e.g., 3 Years)
                  Text(
                    skill['exp'],
                    style: AppTextStyles.skillExperience,
                  ),
                ],
              ),
            ],
          ),

          // 2. Badge (Right side)
          _buildBadge(skill['badgeText'], skill['badgeColor']),
        ],
      ),
    );
  }
}


// =========================================================================
// WIDGET 4: Skills Section
// =========================================================================
class skillsSection extends StatefulWidget {
  const skillsSection({super.key});

  @override
  State<skillsSection> createState() => _skillsSectionState();
}

class _skillsSectionState extends State<skillsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle(title: "Skills Used"),
        const SizedBox(height: 10),

        // --- Responsive Grid for Skills ---
        ResponsiveGridList(
          minItemWidth: 300,
          listViewBuilderOptions:  ListViewBuilderOptions(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          horizontalGridSpacing: 15,
          verticalGridSpacing: 15,

          children: skillsUsedList.map((skill) {
            return SkillItem(skill: skill);
          }).toList(),
        ),
      ],
    );
  }
}

// =========================================================================
// WIDGET 5: Project Website Button (NEW)
// =========================================================================
class ProjectWebsiteButton extends StatelessWidget {
  // Use the same color as the AppBar: 0xFF9169F0
  static const Color buttonColor = Color(0xFF9169F0);
  // Placeholder URL
  static const String projectUrl = 'https://www.example.com/project-website';

  const ProjectWebsiteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make the button full width
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          _launchUrl(projectUrl);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Rounded pill shape
          ),
          elevation: 5, // Subtle shadow
        ),
        child: const Text(
          'Go to Project Website',
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }
}


// =========================================================================
// WIDGET 6: Main Screen (Project1) - Full Solution
// =========================================================================
class Project1 extends StatelessWidget {
  const Project1({super.key});

  // Helper function to calculate the horizontal margin
  double _getHorizontalMargin(double width) {
    if (width < 600) {
      return 20; // Fixed padding for phones
    } else if (width < 1200) {
      // Small margin for tablets
      return width * 0.05; // 5% margin (50-60px)
    } else {
      // Larger margin for desktops to constrain content width
      return width * 0.15; // 15% margin (180px+)
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = _getHorizontalMargin(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project1 Name'),
        backgroundColor: const Color(0xFF9169F0),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Apply dynamic horizontal margin and a fixed vertical margin
            padding: EdgeInsets.only(
              left: horizontalMargin,
              right: horizontalMargin,
              top: 20,
              bottom: 40, // Increased bottom padding for button visibility
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Project Description Section
                ProjectDescriptionSection(),

                // Spacer
                SizedBox(height: 30),

                // 2. Screenshot Section
                screenshotSection(),

                // Spacer
                SizedBox(height: 30),

                // 3. Key Feature Section
                keyfeatureSection(),

                // Spacer
                SizedBox(height: 30),

                // 4. Skills Section
                skillsSection(),

                // Spacer before the button
                SizedBox(height: 40),

                // 5. Project Website Button (NEW)
                ProjectWebsiteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}