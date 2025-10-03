import 'package:flutter/material.dart'; // Core Flutter material design library. UI Part.
import 'package:responsive_grid_list/responsive_grid_list.dart'; // UI Part: Enables dynamic arrangement of skill cards.

// The main widget for the Skills screen
class Skills extends StatefulWidget {
  // Defines the main Skills screen widget.
  const Skills({super.key}); // Constructor.

  @override
  State<Skills> createState() => _SkillsState(); // Creates the mutable state.
}

class _SkillsState extends State<Skills> {
  // The state class managing the data and UI state.
  // ... (existing state and data structure)
  String searchQuery = ""; // State: Holds the text entered in the search bar.
  String selectedTab =
      "All"; // State: Tracks the currently active category filter tab.
  final Map<String, List<Map<String, dynamic>>> skillsData = const {
    // Logic Part: The static source of all skill data, organized by category.
    // Making data const as good practice if possible
    "Languages": [
      // First category: Languages.
      {
        "name": "HTML",
        "exp": "4 years experience",
        "icon": Icons.language,
      }, // Individual skill entry.
      {"name": "CSS", "exp": "4 years experience", "icon": Icons.style},
      {"name": "TypeScript", "exp": "4 years experience", "icon": Icons.code},
      {"name": "SQL", "exp": "Basics", "icon": Icons.storage},
      {"name": "Dart", "exp": "Just started", "icon": Icons.bolt},
    ],
    "Frameworks": [
      // Second category: Frameworks.
      {"name": "Angular", "exp": "4 years experience", "icon": Icons.web},
      {"name": "Bootstrap", "exp": "3 years experience", "icon": Icons.layers},
      {"name": "Flutter", "exp": "Just started", "icon": Icons.flutter_dash},
    ],
    "Tools": [
      // Third category: Tools.
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
      // Fourth category: Platforms.
      {"name": "Web", "exp": "", "icon": Icons.public},
      {"name": "Android", "exp": "", "icon": Icons.phone_android},
    ],
  };

  final List<String> tabs = const [
    // Logic Part: List used to build the filter tabs UI.
    "All",
    "Languages",
    "Frameworks",
    "Tools",
    "Platforms",
  ];

  Map<String, List<Map<String, dynamic>>> _getFilteredSkills() {
    // Logic Part: Filters the raw skills data based on current state (tab and search).
    final Map<String, List<Map<String, dynamic>>> filteredSkillsByCategories =
        {}; // Initializes the map for filtered results.

    skillsData.entries.forEach((entry) {
      // Iterates through each category in the raw data.
      final category = entry.key;

      if (selectedTab != "All" && selectedTab != category) {
        // Logic Part: Checks the selected tab filter.
        return; // Skips categories that don't match the selected tab (unless "All" is selected).
      }

      final items = entry.value.where((skill) {
        // Filters individual skills within the category.
        if (searchQuery.isEmpty)
          return true; // Shows all skills if the search query is empty.
        return skill["name"]!.toLowerCase().contains(
              searchQuery,
            ) || // Logic Part: Checks if skill name matches search query.
            category.toLowerCase().contains(
              searchQuery,
            ); // Logic Part: Checks if category name matches search query.
      }).toList(); // Converts the filtered iterable back to a list.

      if (items.isNotEmpty) {
        // Only adds the category to the result if it contains matching skills.
        filteredSkillsByCategories[category] = items;
      }
    });

    return filteredSkillsByCategories; // Returns the processed, filtered data structure.
  }

  // --- Sticky Header Implementation ---
  SliverPersistentHeader _buildStickyHeader({required double screenWidth}) {
    // UI Logic: Builds the custom sticky header widget.
    // 1. Calculate horizontal padding based on screen size (same as main body padding)
    final double horizontalPadding = screenWidth > 800
        ? 120
        : 16; // UI Logic: Calculates dynamic padding for responsiveness.

    // 2. Define the main content widget for the header (Tabs + Search)
    final Widget headerContent = Container(
      // Container for the header's background and padding.
      // The color of the header when it's sticky (typically matches Scaffold background)
      color: Colors
          .white, // Ensures the header looks seamless against the background when pinned.
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding, // Applies responsive horizontal padding.
        vertical: 16,
      ),
      child: Column(
        // Vertical stack for the tabs and the search bar.
        mainAxisSize:
            MainAxisSize.min, // Essential for column inside a min-height header
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tabs Section (NEW: Centered on wide screens)
          Center(
            // Centers the row of tabs horizontally.
            child: SingleChildScrollView(
              // Allows the tabs to scroll horizontally if the screen is too narrow.
              scrollDirection: Axis.horizontal,
              child: Row(
                // Container for the individual tabs.
                children: tabs.map((tab) {
                  // Maps the tab names list to interactive widgets.
                  final isSelected =
                      selectedTab ==
                      tab; // UI Logic: Determines the visual state of the tab.
                  return GestureDetector(
                    // Makes the tab container tappable.
                    onTap: () {
                      // Action on tap.
                      setState(() {
                        selectedTab =
                            tab; // Updates the selectedTab state variable, triggering a rebuild and filtering.
                      });
                    },
                    child: Container(
                      // Visual container for a single tab button.
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        // Styling based on selection status.
                        color: isSelected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab, // Tab title.
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
          ),
          const SizedBox(height: 16), // Space between tabs and search bar.
          // Search Bar
          TextField(
            // UI Part: The input field for searching skills.
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
              // Logic Part: Callback triggered when text in the field changes.
              setState(() {
                searchQuery = val
                    .toLowerCase(); // Updates the searchQuery state variable, triggering a rebuild and filtering.
              });
            },
          ),
        ],
      ),
    );

    // 3. Return the SliverPersistentHeader delegate
    return SliverPersistentHeader(
      // UI Part: The widget that makes its content "sticky" when scrolling.
      pinned: true, // Key property: makes the header sticky
      delegate: _SliverAppBarDelegate(
        // Uses a custom delegate to define height and content.
        minHeight: 160.0, // Minimum height when sticky
        maxHeight: 160.0, // Maximum height (should equal min if not collapsing)
        child: headerContent, // Passes the tabs and search bar UI.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSkillsByCategories =
        _getFilteredSkills(); // Logic Part: Calls the filter method to get the data to display.
    final totalFilteredSkills = filteredSkillsByCategories.values.fold<int>(
      // Logic Part: Calculates the total count of visible skills.
      0,
      (sum, list) => sum + list.length,
    );

    // Main build structure now uses LayoutBuilder and CustomScrollView
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // UI Part: Standard top app bar for the screen title.
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
        // UI Logic: Used to get the exact width constraints for responsive padding.
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final double horizontalPadding = screenWidth > 800
              ? 120
              : 16; // Calculates responsive padding.

          return CustomScrollView(
            // UI Part: Provides scrollability and supports sliver widgets (like the sticky header).
            slivers: <Widget>[
              // The list of scrollable components.
              // 1. Sticky Header (Tabs + Search)
              _buildStickyHeader(
                screenWidth: screenWidth,
              ), // Inserts the custom sticky header.
              // 2. Main Skills Content (SliverList)
              SliverPadding(
                // Applies padding specifically to the scrollable content below the header.
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, // Applies responsive padding.
                  vertical:
                      24, // Added top vertical padding below the sticky header
                ),
                sliver:
                    totalFilteredSkills ==
                        0 // Logic/UI Part: Conditional rendering based on filter results.
                    ? SliverFillRemaining(
                        // UI Part: Used to show centered content when there are no items.
                        hasScrollBody:
                            false, // Don't allow it to scroll if content is short
                        child: Center(
                          // Centers the "no results" message.
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.sentiment_dissatisfied,
                                size: 60,
                                color: Colors.grey,
                              ),
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverList(
                        // UI Part: Displays the list of skill categories.
                        delegate: SliverChildListDelegate(
                          filteredSkillsByCategories.entries.map((entry) {
                            // Maps the filtered data to category headers and skill grids.
                            final category = entry.key;
                            final items = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ), // Spacing between different categories.
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Header
                                  Text(
                                    // Displays the category title (e.g., "LANGUAGES").
                                    category.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Responsive Grid for Cards
                                  ResponsiveGridList(
                                    // UI Part: Grid for the skill cards within the category.
                                    listViewBuilderOptions: ListViewBuilderOptions(
                                      shrinkWrap: true,
                                      physics:
                                          NeverScrollableScrollPhysics(), // Ensures grid doesn't scroll independently.
                                    ),
                                    minItemWidth:
                                        160, // Minimum width of each skill card.
                                    horizontalGridSpacing: 16,
                                    verticalGridSpacing: 16,
                                    children: items.map((skill) {
                                      // Maps the skill data to the card widget builder.
                                      return _buildSkillCard(
                                        // Calls the helper method to build the card UI.
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
    // UI Part: Builds the visual representation of one skill.
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Card styling with white background, rounded corners, and shadow.
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
        // Content arranged vertically (Icon, Title, Experience).
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue), // Displays the skill icon.
          const SizedBox(height: 8),
          Text(
            title, // Displays the skill name.
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            exp, // Displays the experience level.
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
  // Logic/Integration Part: Required class for creating a custom sticky header.
  _SliverAppBarDelegate({
    // Constructor receives properties for the header.
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double
  minHeight; // Required property: height when fully collapsed/pinned.
  final double maxHeight; // Required property: height when fully expanded.
  final Widget child; // The content widget to be displayed.

  @override
  double get minExtent => minHeight; // Getter returns the minimum height.

  @override
  double get maxExtent => maxHeight; // Getter returns the maximum height.

  // The main widget to build, which is our sticky header content
  @override
  Widget build(
    // UI Part: Method called by CustomScrollView to render the header at the current scroll position.
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: child,
    ); // Ensures the child fills the determined height/width.
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    // Logic Part: Determines if the header needs to be rebuilt when the widget changes.
    return maxHeight != oldDelegate.maxHeight || // Checks if height changed.
        minHeight != oldDelegate.minHeight || // Checks if height changed.
        child != oldDelegate.child; // Checks if the content widget changed.
  }
}
