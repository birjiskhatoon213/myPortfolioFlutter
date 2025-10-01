// projects.dart (Native Solution - Full Screen Responsive)

import 'package:flutter/material.dart';
import 'package:textf/textf.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ===========================================
// 1. DATA STRUCTURE
// ===========================================
class Project {
  final String title;
  final String description;
  final String imagePath;
  final String detailsRoute;

  Project({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.detailsRoute,
  });
}

// Your list of 8 projects (using placeholder data)
final List<Project> projects = [
  Project(
    title: "Medcall UI/UX Case Study",
    description:
        "Medcall a one-stop healthcare app in India. Book health check packages, schedule lab tests, consult with doctors virtually, and order medicines for same-day delivery, all in one place.",
    imagePath: 'images/project1.jpg',
    detailsRoute: '/Project1',
  ),
  Project(
    title: "Aignit - Instant AI Answer Analysis",
    description:
        "Aignit's algorithm evaluates your answers and offers actionable feedback. A structured feedback designed to enhance your answer writing across multiple domains.",
    imagePath: 'images/project2.jpg',
    detailsRoute: '/Project1',
  ),
  Project(
    title: "My time @Cars24",
    description:
        "Founded in 2015, CARS24 is a leading AutoTech company streamlining and revolutionising the sale, purchase, and financing of pre-owned cars in India, Australia, Thailand, and UAE.",
    imagePath: 'images/project3.jpg',
    detailsRoute: '/p3_details',
  ),
  Project(
    title: "Grabon 2.0 - Logo, Branding and  Identity",
    description:
        "Grabon is a trusted brand and a pioneer in affiliate e-commerce scene in India. We are known for maintaining high quality standards through our unique user interface and user experience.",
    imagePath: 'images/project1.jpg',
    detailsRoute: '/p4_details',
  ),
  Project(
    title: "Grabon App - Redesign",
    description:
        "Grabon is a trusted brand and a pioneer in affiliate e-commerce scene in India. We are known for maintaining high quality standards through our unique user interface and user experience.",
    imagePath: 'images/project2.jpg',
    detailsRoute: '/p5_details',
  ),
  Project(
    title: "OLA Rebranding & Product design (Concept)",
    description:
        "Grabon is a trusted brand and a pioneer in affiliate e-commerce scene in India. We are known for maintaining high quality standards through our unique user interface and user experience.",
    imagePath: 'images/project3.jpg',
    detailsRoute: '/p6_details',
  ),
  Project(
    title: "Cita EV Charger App",
    description:
        "EV Car Charge Management Application, An application to manage EV charge status & setup",
    imagePath: 'images/project1.jpg',
    detailsRoute: '/p7_details',
  ),
  Project(
    title: "Cita Smart Cameras App",
    description:
        "Surveillance Camera Management Application, Application to manage Surveillance Cameras on mobile",
    imagePath: 'images/project2.jpg',
    detailsRoute: '/p8_details',
  ),
  Project(
    title: "TracePe Application",
    description:
        "Tracepe is the best subscription management platform which helps you manage all subscriptions, cancel subscriptions and track subscriptions, all at one place.",
    imagePath: 'images/project3.jpg',
    detailsRoute: '/p9_details',
  ),
  Project(
    title: "Skoolcom Application",
    description:
        "Grabon is a trusted brand and a pioneer in affiliate e-commerce scene in India. We are known for maintaining high quality standards through our unique user interface and user experience.",
    imagePath: 'images/project1.jpg',
    detailsRoute: '/p8_details',
  ),
  Project(
    title: "Cita EV Charge Station Management Dashboard",
    description:
        "EV Station Management Dashboard Application (Internal Tool) Application to manage EV Station managers and staff and diagnose and setup EV stations.",
    imagePath: 'images/project2.jpg',
    detailsRoute: '/p8_details',
  ),
];

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth > 800 ? 120 : 0, // Only for large screens
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100),
                Container(child: ProjectMainDescription()),
                const SizedBox(height: 100),
                Container(child: projectCards()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ProjectMainDescription extends StatelessWidget {
//   // by using simple rich text style
//   const ProjectMainDescription({super.key});
//
//   // Base style is defined once
//   static const TextStyle _baseStyle = TextStyle(
//     fontSize: 35,
//     fontFamily: 'Poppins',
//     fontWeight: FontWeight.w400,
//     height: 1.2,
//     color: Colors.black,
//   );
//
//   // Bold style is defined once
//   static const TextStyle _boldStyle = TextStyle(
//     fontSize: 35,
//     fontFamily: 'Poppins',
//     fontWeight: FontWeight.w700, // The key difference
//     height: 1.2,
//     color: Colors.black,
//   );
//
//   // Helper function to create a bold TextSpan (optional, but saves characters)
//   TextSpan _b(String text) => TextSpan(text: text, style: _boldStyle);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: RichText(
//         text: TextSpan(
//           style: _baseStyle,
//           children: <TextSpan>[
//             const TextSpan(text: "I design with "),
//             _b("intention"),
//             const TextSpan(text: " not noice. I don't chase "),
//             _b("Dribbble"),
//             const TextSpan(text: " likes or design "),
//             _b("Twitter hype. "),
//             const TextSpan(text: "I care about "),
//             _b("clarity, "),
//             _b("speed,"),
//             const TextSpan(text: " and building things that "),
//             _b("actually ship. "),
//             const TextSpan(text: "I make "),
//             _b("systems"),
//             const TextSpan(text: " that scale, "),
//             _b("flows that "),
//             _b("convert,"),
//             const TextSpan(text: " and work that makes "),
//             _b("noise."),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ProjectMainDescription extends StatelessWidget {
  // by using easy rich text pattern package
  const ProjectMainDescription({super.key});

  // 1. Define the full text as a single constant string
  static const String fullText =
      "I design with intention not noice. I don't chase Dribbble likes or design Twitter hype. I care about clarity, speed and building things that actually ship. I make systems that scale, flows that convert and work that makes noise.";

  // Define the base style once
  static const TextStyle _baseStyle = TextStyle(
    fontSize: 27,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: Colors.black,
  );

  // Define the bold style once
  static const TextStyle _boldStyle = TextStyle(
    fontSize: 27,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    // 2. Define a list of all words that should be BOLD
    final List<String> boldWords = [
      'intention',
      'Dribbble',
      'Twitter hype', // Note: You can style phrases too!
      'clarity',
      'speed',
      'actually ship',
      'systems',
      'flows',
      'convert',
      'noise',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: EasyRichText(
        fullText, // Pass the single string
        defaultStyle: _baseStyle, // Apply the base style
        // 3. Define the pattern that finds all boldWords and applies _boldStyle
        patternList: [
          EasyRichTextPattern(
            targetString: boldWords.join(
              '|',
            ), // Join all words with '|' for a Regex OR condition
            style: _boldStyle,
            // Use word boundaries to ensure 'speed' is matched but not 'speedy'
            matchWordBoundaries:
                false, // Set to false to allow partial matches like 'Twitter hype'
          ),
        ],
      ),
    );
  }
}

class projectCards extends StatefulWidget {
  const projectCards({super.key});

  @override
  State<projectCards> createState() => _projectCardsState();
}

class _projectCardsState extends State<projectCards> {
  // Helper method to determine the number of columns based on screen width
  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) {
      return 1; // 1 column for phones
    }
    // else if (screenWidth < 900) {
    //   return 2; // 2 columns for tablets
    // }
    else {
      return 2; // 3 columns for desktop/large screens
    }
  }

  // Helper method to create a single Card widget
  Widget _buildProjectCard(BuildContext context, Project project) {
    double screenWidth = MediaQuery.of(context).size.width;
    int getFlex(double width) {
      if (width < 600) return 3; // Mobile
      if (width < 800) return 4; // Tablet
      if (width < 1200) return 3;
      return 1; // Desktop
    }

    return InkWell(
      onTap: () {
        // Handle tap, e.g., navigate to details page
        Navigator.pushNamed(context, project.detailsRoute);
      },
      // child: Card(
      //   elevation: 8.0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(10.0),
      //   ),
      //   clipBehavior:
      //       Clip.antiAlias, // Ensures content is clipped to border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1. Image Section
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // All 4 corners rounded
              child: Image.asset(
                project.imagePath,
                fit: BoxFit.cover,
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
            ),
          ),

          // 2. Project Name and Description Section
          Expanded(
            flex: getFlex(screenWidth),
            // child: Padding(
            // padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // ),
          ),
        ],
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // GridView.builder for a responsive, scrollable list of cards
      child: GridView.builder(
        // Important: ShrinkWrap true and disable scrolling because the outer ListView handles it
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          // Number of columns changes with screen size
          crossAxisSpacing: 20.0,
          // Horizontal space between cards
          mainAxisSpacing: 20.0,
          // Vertical space between cards
          childAspectRatio: 0.8,
          // Aspect ratio (width/height) of each item. Tune this for card height.
        ),
        itemBuilder: (context, index) {
          return _buildProjectCard(context, projects[index]);
        },
      ),
    );
  }
}
