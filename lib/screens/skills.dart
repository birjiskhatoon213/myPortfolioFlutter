import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

// The main widget for the Skills screen
class Skills extends StatefulWidget {
  const Skills({super.key});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  // ... (existing state and data structure)
  String searchQuery = "";
  String selectedTab = "All";
  final Map<String, List<Map<String, dynamic>>> skillsData = const {
    // Making data const as good practice if possible
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

  final List<String> tabs = const [
    "All",
    "Languages",
    "Frameworks",
    "Tools",
    "Platforms",
  ];

  Map<String, List<Map<String, dynamic>>> _getFilteredSkills() {
    final Map<String, List<Map<String, dynamic>>> filteredSkillsByCategories = {};

    skillsData.entries.forEach((entry) {
      final category = entry.key;

      if (selectedTab != "All" && selectedTab != category) {
        return;
      }

      final items = entry.value.where((skill) {
        if (searchQuery.isEmpty) return true;
        return skill["name"]!.toLowerCase().contains(searchQuery) ||
            category.toLowerCase().contains(searchQuery);
      }).toList();

      if (items.isNotEmpty) {
        filteredSkillsByCategories[category] = items;
      }
    });

    return filteredSkillsByCategories;
  }

  // --- Sticky Header Implementation ---
  SliverPersistentHeader _buildStickyHeader({required double screenWidth}) {
    // 1. Calculate horizontal padding based on screen size (same as main body padding)
    final double horizontalPadding = screenWidth > 800 ? 120 : 16;

    // 2. Define the main content widget for the header (Tabs + Search)
    final Widget headerContent = Container(
      // The color of the header when it's sticky (typically matches Scaffold background)
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Essential for column inside a min-height header
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tabs Section (NEW: Centered on wide screens)
          Center(
            child: SingleChildScrollView(
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
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar
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
        ],
      ),
    );

    // 3. Return the SliverPersistentHeader delegate
    return SliverPersistentHeader(
      pinned: true, // Key property: makes the header sticky
      delegate: _SliverAppBarDelegate(
        minHeight: 160.0, // Minimum height when sticky
        maxHeight: 160.0, // Maximum height (should equal min if not collapsing)
        child: headerContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSkillsByCategories = _getFilteredSkills();
    final totalFilteredSkills = filteredSkillsByCategories.values.fold<int>(
      0,
          (sum, list) => sum + list.length,
    );

    // Main build structure now uses LayoutBuilder and CustomScrollView
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final double horizontalPadding = screenWidth > 800 ? 120 : 16;

          return CustomScrollView(
            slivers: <Widget>[
              // 1. Sticky Header (Tabs + Search)
              _buildStickyHeader(screenWidth: screenWidth),

              // 2. Main Skills Content (SliverList)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 24, // Added top vertical padding below the sticky header
                ),
                sliver: totalFilteredSkills == 0
                    ? SliverFillRemaining(
                  hasScrollBody: false, // Don't allow it to scroll if content is short
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
                  ),
                )
                    : SliverList(
                  delegate: SliverChildListDelegate(
                    filteredSkillsByCategories.entries.map((entry) {
                      final category = entry.key;
                      final items = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
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
                            const SizedBox(height: 12),

                            // Responsive Grid for Cards
                            ResponsiveGridList(
                              listViewBuilderOptions:  ListViewBuilderOptions(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              ),
                              minItemWidth: 160,
                              horizontalGridSpacing: 16,
                              verticalGridSpacing: 16,
                              children: items.map((skill) {
                                return _buildSkillCard(
                                  skill["name"]!,
                                  skill["exp"]!,
                                  skill["icon"]!,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
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
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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

// --- SliverPersistentHeader Delegate ---
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  // The main widget to build, which is our sticky header content
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}