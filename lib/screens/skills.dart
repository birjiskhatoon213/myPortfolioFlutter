import 'package:flutter/material.dart';

// The main widget for the Skills screen, making it a StatefulWidget to manage
// internal state like selected tabs and search queries.
class Skills extends StatefulWidget {
  const Skills({super.key});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  // Holds the current text entered in the search bar.
  // It is converted to lowercase for case-insensitive searching later.
  String searchQuery = "";

  // Tracks the currently selected category tab (e.g., "Languages", "Tools").
  // Initialized to "All" to show all skills by default.
  String selectedTab = "All"; // ✅ default tab

  // ✅ Data structure to hold all skill information, grouped by category.
  // Each category maps to a list of skill objects (Map<String, dynamic>).
  final Map<String, List<Map<String, dynamic>>> skillsData = {
    "Languages": [
      // Each skill object contains the name, experience, and an associated icon.
      {"name": "HTML", "exp": "4 years experience", "icon": Icons.language},
      {"name": "CSS", "exp": "4 years experience", "icon": Icons.style},
      {"name": "TypeScript", "exp": "4 years experience", "icon": Icons.code},
      {"name": "SQL", "exp": "Basics", "icon": Icons.storage},
      {"name": "Dart", "exp": "Just started", "icon": Icons.bolt},
    ],
    "Frameworks": [
      {"name": "Angular", "exp": "4 years experience", "icon": Icons.web},
      {"name": "Bootstrap", "exp": "3 years experience", "icon": Icons.layers},
      {"name": "Flutter", "exp": "Just started", "icon": Icons.flutter_dash},
    ],
    "Tools": [
      {"name": "Android Studio", "exp": "Just started", "icon": Icons.android},
      {"name": "Git", "exp": "3+ years experience", "icon": Icons.merge_type},
      // ... (rest of the Tools data)
      {
        "name": "Swagger",
        "exp": "2+ years experience",
        "icon": Icons.description,
      },
      {"name": "Katalon", "exp": "Basics", "icon": Icons.bug_report},
      {"name": "Figma", "exp": "Basics", "icon": Icons.design_services},
      {
        "name": "NVDA",
        "exp": "Accessibility Testing",
        "icon": Icons.record_voice_over,
      },
      {"name": "Responsive Design", "exp": "", "icon": Icons.devices},
      {"name": "API Integration", "exp": "", "icon": Icons.api},
      {"name": "Debugging", "exp": "", "icon": Icons.bug_report_outlined},
      {"name": "Testing", "exp": "", "icon": Icons.check_circle},
    ],
    "Platforms": [
      {"name": "Web", "exp": "", "icon": Icons.public},
      {"name": "Android", "exp": "", "icon": Icons.phone_android},
    ],
  };

  // List of category names used to build the horizontal tab bar.
  final List<String> tabs = [
    "All", // Must be the first element to match the initial selectedTab value.
    "Languages",
    "Frameworks",
    "Tools",
    "Platforms",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sets the overall background of the screen to white.
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Skills"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the AppBar.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ===============================================================
            // ✅ Tabs Section
            // ===============================================================
            SingleChildScrollView(
              // Allows the tabs to be scrolled horizontally if they exceed screen width.
              scrollDirection: Axis.horizontal,
              child: Row(
                // Maps the 'tabs' list into a list of interactive tab widgets.
                children: tabs.map((tab) {
                  final isSelected = selectedTab == tab;
                  return GestureDetector(
                    // onTap logic handles switching the active tab.
                    onTap: () {
                      // Calls setState to rebuild the widget tree with the new selectedTab.
                      setState(() {
                        selectedTab = tab;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        // Changes color based on selection status.
                        color: isSelected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          // Makes the text bold when selected.
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // ===============================================================
            // ✅ Search Bar Section
            // ===============================================================
            TextField(
              decoration: InputDecoration(
                hintText: "Search skills...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    30,
                  ), // Rounded corners for a pill shape.
                  borderSide: BorderSide.none, // Removes the border line.
                ),
                fillColor: Colors.grey.shade200,
                filled: true, // Enables the background color (fillColor).
              ),
              // Called every time the text field content changes.
              onChanged: (val) {
                // Updates the searchQuery state variable, triggering a rebuild.
                setState(() {
                  // Stores the input in lowercase for case-insensitive filtering.
                  searchQuery = val.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),

            // ===============================================================
            // ✅ Scrollable Skills List Section (Filtered Content)
            // ===============================================================
            Expanded(
              // Ensures the list takes up the remaining vertical space.
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // Iterates over all skill categories (skillsData map entries).
                  children: skillsData.entries.map((entry) {
                    final category = entry.key;

                    // 1. ✅ Tab filter: Skips rendering the category if it doesn't match the selected tab.
                    if (selectedTab != "All" && selectedTab != category) {
                      return const SizedBox(); // Renders an empty widget if filtered out.
                    }

                    // 2. ✅ Search filter: Filters the skills within the current category.
                    final items = entry.value.where((skill) {
                      // If search is empty, show all skills in this category.
                      if (searchQuery.isEmpty) return true;

                      // Check if the skill name contains the search query.
                      return skill["name"]!.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          // Also check if the category name contains the search query.
                          category.toLowerCase().contains(searchQuery);
                    }).toList();

                    // If all skills in this category were filtered out by the search, skip rendering the category header.
                    if (items.isEmpty) return const SizedBox();

                    // Builds the category header and the skill cards.
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Header
                        Text(
                          category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Wrap widget allows skill cards to flow onto the next line responsively.
                        Wrap(
                          spacing: 12, // Horizontal space between cards.
                          runSpacing:
                              12, // Vertical space between lines of cards.
                          // Maps the filtered 'items' into _buildSkillCard widgets.
                          children: items.map((skill) {
                            return _buildSkillCard(
                              skill["name"]!,
                              skill["exp"]!,
                              skill["icon"],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // ✅ Skill Card Widget Definition
  // ===============================================================
  Widget _buildSkillCard(String title, String exp, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Creates a subtle shadow effect for depth.
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Margin to create space around the card, separate from the Wrap's spacing.
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // Fixed width for the card (you may need to change this for responsiveness).
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            exp,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            // If the content is large, this text might wrap, making the card taller.
            // If you want fixed height, you would need to set maxLines and overflow properties here.
          ),
        ],
      ),
    );
  }
}
