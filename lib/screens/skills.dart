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
  String searchQuery = "";

  // Tracks the currently selected category tab.
  String selectedTab = "All"; // ✅ default tab

  // ✅ Data structure to hold all skill information, grouped by category.
  final Map<String, List<Map<String, dynamic>>> skillsData = {
    "Languages": [
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
    "All",
    "Languages",
    "Frameworks",
    "Tools",
    "Platforms",
  ];

  // Helper method to apply filtering logic and return the filtered data structure
  Map<String, List<Map<String, dynamic>>> _getFilteredSkills() {
    final Map<String, List<Map<String, dynamic>>> filteredSkillsByCategories =
        {};

    skillsData.entries.forEach((entry) {
      final category = entry.key;

      // 1. Apply Tab Filter: Skip if category doesn't match the selected tab
      if (selectedTab != "All" && selectedTab != category) {
        return;
      }

      // 2. Apply Search Filter:
      final items = entry.value.where((skill) {
        if (searchQuery.isEmpty) return true;
        // Check both skill name and category name against the search query
        return skill["name"]!.toLowerCase().contains(searchQuery) ||
            category.toLowerCase().contains(searchQuery);
      }).toList();

      // Only include the category in the result if it has matching items
      if (items.isNotEmpty) {
        filteredSkillsByCategories[category] = items;
      }
    });

    return filteredSkillsByCategories;
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 NEW LOGIC START: Calculate filtered skills and total count
    final filteredSkillsByCategories = _getFilteredSkills();
    // Sum the length of all lists in the map to get the total count of visible skills.
    final totalFilteredSkills = filteredSkillsByCategories.values.fold<int>(
      0,
      (sum, list) => sum + list.length,
    );

    // Widget to be placed in the Expanded area (either skill list or 'not found' message)
    Widget skillContent;

    if (totalFilteredSkills == 0) {
      // Show 'No Skills Found' message in center
      skillContent = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No skills found for your search.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Try a different search term or tab.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      // Show the filtered skill cards
      skillContent = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Use the pre-filtered map entries
          children: filteredSkillsByCategories.entries.map((entry) {
            final category = entry.key;
            final items = entry.value;

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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
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
      );
    }
    // 🚀 NEW LOGIC END

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Skills"),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 30,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16,top: 16,right: 16),
        child: Column(
          children: [
            // Tabs Section (Unchanged)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs.map((tab) {
                  final isSelected = selectedTab == tab;
                  return GestureDetector(
                    onTap: () {
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
                        color: isSelected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
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

            // Search Bar Section (Unchanged)
            TextField(
              decoration: InputDecoration(
                hintText: "Search skills...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),

            // Expanded section now uses the determined skillContent widget
            Expanded(child: skillContent),
          ],
        ),
      ),
    );
  }

  // Skill Card Widget Definition (Unchanged)
  Widget _buildSkillCard(String title, String exp, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          ),
        ],
      ),
    );
  }
}
