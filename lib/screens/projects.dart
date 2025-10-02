// projects.dart (Native Solution - Full Screen Responsive)

import 'package:flutter/material.dart';
// NOTE: Make sure to add this dependency to your pubspec.yaml:
// responsive_grid_list: ^1.4.1
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

// ===========================================
// 1. DATA STRUCTURE
// ===========================================
class Project {
  final String title;
  final String description;
  final String imagePath; // This now holds the URL
  final String detailsRoute;

  Project({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.detailsRoute,
  });
}

// Your list of 11 projects (using placeholder data)
final List<Project> projects = [
  Project(
    title: "Medcall UI/UX Case Study",
    description:
    "Medcall a one-stop healthcare app in India. Book health check packages, schedule lab tests, consult with doctors virtually, and order medicines for same-day delivery, all in one place.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=1',
    detailsRoute: '/Project1',
  ),
  Project(
    title: "Aignit - Instant AI Answer Analysis",
    description:
    "Aignit's algorithm offers actionable feedback to enhance your answer writing across multiple domains.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=2',
    detailsRoute: '/Project1',
  ),
  Project(
    title: "My time @Cars24",
    description:
    "CARS24 is a leading AutoTech company streamlining and revolutionising the sale, purchase, and financing of pre-owned cars in India.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=3',
    detailsRoute: '/p3_details',
  ),
  Project(
    title: "Grabon 2.0 - Logo, Branding and  Identity",
    description:
    "Grabon is a trusted brand and a pioneer in affiliate e-commerce scene in India, known for high quality standards.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=4',
    detailsRoute: '/p4_details',
  ),
  Project(
    title: "Grabon App - Redesign",
    description:
    "Grabon is a trusted brand and a pioneer in affiliate e-commerce scene in India. We are known for maintaining high quality standards.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=5',
    detailsRoute: '/p5_details',
  ),
  Project(
    title: "OLA Rebranding & Product design (Concept)",
    description:
    "Concept design exploring rebranding possibilities and product redesign for the OLA transportation platform.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=6',
    detailsRoute: '/p6_details',
  ),
  Project(
    title: "Cita EV Charger App",
    description:
    "EV Car Charge Management Application, An application to manage EV charge status & setup.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=7',
    detailsRoute: '/p7_details',
  ),
  Project(
    title: "Cita Smart Cameras App",
    description:
    "Surveillance Camera Management Application, Application to manage Surveillance Cameras on mobile.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=8',
    detailsRoute: '/p8_details',
  ),
  Project(
    title: "TracePe Application",
    description:
    "Tracepe is the best subscription management platform which helps you manage all subscriptions, cancel subscriptions and track subscriptions, all at one place.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=9',
    detailsRoute: '/p9_details',
  ),
  Project(
    title: "Skoolcom Application",
    description:
    "Skoolcom is a platform for managing school communications, attendance, and academic records digitally.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=10',
    detailsRoute: '/p8_details',
  ),
  Project(
    title: "Cita EV Charge Station Management Dashboard",
    description:
    "EV Station Management Dashboard Application (Internal Tool) Application to manage EV Station managers and staff and diagnose and setup EV stations.",
    // --- CHANGED TO NETWORK URL ---
    imagePath: 'https://picsum.photos/300/600?random=11',
    detailsRoute: '/p8_details',
  ),
];

// ===========================================
// MAIN SCREEN WIDGET
// ===========================================
class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  // Helper method to determine the horizontal margin based on screen width
  double _getMargin(double width) {
    if (width < 800) {
      return 0; // No margin on smaller screens
    } else if (width < 1200) {
      return width * 0.1; // 10% margin on tablets
    } else {
      return width * 0.15; // 15% margin on large screens
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Ensures content respects system overlays
        child: SingleChildScrollView(
          // Allows the entire page content to scroll
          child: Container(
            // Apply responsive horizontal margin
            margin: EdgeInsets.symmetric(
              horizontal: _getMargin(screenWidth),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
              children: <Widget>[
                SizedBox(height: 100), // Top spacing
                ProjectMainDescription(),
                SizedBox(height: 100), // Spacing between text and cards
                ProjectCards(), // Renamed to use proper PascalCase
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================
// PROJECT MAIN DESCRIPTION WIDGET
// ===========================================
class ProjectMainDescription extends StatelessWidget {
  const ProjectMainDescription({super.key});

  static const String fullText =
      "I develop applications based on exact requirements, carefully handling all possible scenarios. I deliver solutions efficiently while maintaining high-quality standards, follow timelines strictly, and ensure the code is clean, maintainable, and scalable. I focus on building apps that perform well, are easy to extend, and provide real value to users, while collaborating effectively with teams to ship features that work in the real world.";

  static const TextStyle _baseStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: Colors.black,
  );

  static const TextStyle _boldStyle = TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
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

    String targetPattern = boldPhrases.map((phrase) {
      String escapedPhrase = phrase.replaceAllMapped(
          RegExp(r'([.+*?^$(){}|[\]\\])'),
              (match) => r'\' + match.group(0)!
      );
      return '($escapedPhrase)';
    }).join('|');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: EasyRichText(
        fullText,
        defaultStyle: _baseStyle,
        patternList: [
          EasyRichTextPattern(
            targetString: targetPattern,
            style: _boldStyle,
            matchWordBoundaries: false,
          ),
        ],
      ),
    );
  }
}

// ===========================================
// PROJECT CARDS WIDGET - USING responsive_grid_list
// ===========================================
class ProjectCards extends StatelessWidget {
  const ProjectCards({super.key});

  // Helper method to create a single Card widget, simplified for the grid
  Widget _buildProjectCard(BuildContext context, Project project) {
    // The InkWell wraps the entire card area and makes it tappable
    return InkWell(
      onTap: () {
        // Handle tap, e.g., navigate to details page
        Navigator.pushNamed(context, project.detailsRoute);
      },
      child: Container(
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
        // Column stacks the Image and Text content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Image Section (Takes a fixed proportion of the card)
            Flexible(
              flex: 5, // Give the image more weight/height
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Image width:height ratio (e.g., 16:9)
                  // --- KEY CHANGE: Image.network for external URLs ---
                  child: Image.network(
                    project.imagePath,
                    fit: BoxFit.cover,
                    // Show a progress indicator while loading
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    // Show a broken image icon on error
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                  // --------------------------------------------------
                ),
              ),
            ),

            // 2. Project Name and Description Section (Text Content)
            Flexible(
              flex: 3, // Less weight for the text content
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Essential for content-based height
                  children: <Widget>[
                    // Project Name (Title)
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Project Description
                    Text(
                      project.description,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2, // Limit description height
                      overflow: TextOverflow.ellipsis,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // --- KEY CHANGE: Using ResponsiveGridList ---
      child: ResponsiveGridList(
        // Ensure the grid takes only the vertical space it needs and relies on the parent's scroll.
        listViewBuilderOptions:  ListViewBuilderOptions(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
        // Define the minimum width of an item.
        minItemWidth: 350,

        // Define the spacing between the cards
        horizontalGridSpacing: 25,
        verticalGridSpacing: 25,

        // Generate the list of project cards
        children: projects.map((project) {
          return _buildProjectCard(context, project);
        }).toList(),
      ),
    );
  }
}