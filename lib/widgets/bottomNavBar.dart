import 'package:flutter/material.dart'; // Core Flutter material design library. UI Part.
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'; // Integration Part: Library for custom modal bottom sheet style.
import 'package:responsive_grid_list/responsive_grid_list.dart'; // UI Part: Enables dynamic grid layout for the overflow modal.

// --- Configuration Constants ---
const double _kNavBarHeight =
    80.0; // Logic Part: Defines the fixed height of the bottom navigation bar.

// Master Data List for ALL Destinations
const List<Map<String, dynamic>> allNavSections = [
  // Logic Part: The master list of all available navigation items.
  {
    "title": "Birjis",
    "icon": Icons.person,
    "navIndex": 0,
  }, // navIndex (0) corresponds to MainScreen.
  {"title": "Projects", "icon": Icons.folder_open, "navIndex": 1},
  {"title": "Skills", "icon": Icons.star_border, "navIndex": 2},
  {
    "title": "Contact",
    "icon": Icons.mail,
    "navIndex": 3,
  }, // navIndex (3) is the first overflow item.
  {"title": "Experience", "icon": Icons.work, "navIndex": 4},
  {"title": "Downloads", "icon": Icons.download, "navIndex": 5},
];

// Maximum number of items visible directly on the bottom bar (excluding "More")
const int maxVisibleTabs =
    3; // Logic Part: Configures how many items show directly before the "More" tab appears.

// Definition of the static "More" item
const Map<String, dynamic> moreTab = {
  // Logic Part: The fixed data for the "More" button itself.
  "title": "More",
  "icon": Icons.more_horiz,
  "navIndex":
      -1, // Use a negative index to distinguish it from actual destinations // Logic Part: Placeholder index, used to identify the button.
};

// ----------------------------------------------------------------------
// CustomBottomNavBar
// ----------------------------------------------------------------------

/// A custom bottom navigation bar that supports responsive overflow items
/// via a modal bottom sheet when the number of sections exceeds [maxVisibleTabs].
class CustomBottomNavBar extends StatefulWidget {
  // UI Part: State must be managed to handle the modal open state.
  final int
  currentIndex; // Integration Part: The index of the currently active screen.
  final Function(int)
  onTap; // Integration Part: Callback to change the active screen index in the parent widget.

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // Flag to track if the modal is visually open (to handle button state visually if needed)
  bool _isModalOpen =
      false; // State: Flag to track if the modal is currently showing.

  /// Items visible directly on the bottom navigation bar.
  List<Map<String, dynamic>>
  get _visibleItems => // Logic Part: Returns the items that fit on the main bar.
      allNavSections.sublist(0, maxVisibleTabs);

  /// Items that are hidden and displayed in the overflow modal.
  List<Map<String, dynamic>>
  get _overflowItems => // Logic Part: Returns the items that go into the "More" modal.
      allNavSections.sublist(maxVisibleTabs);

  // --- Modal Bottom Sheet with Responsive Grid ---
  /// Shows the modal bottom sheet containing the overflow navigation items.
  void _showOverflowModal(BuildContext context) async {
    // UI Logic: Function to launch the modal.
    setState(
      () => _isModalOpen = true,
    ); // Updates state before showing the modal.

    await showMaterialModalBottomSheet(
      // UI Part: Uses the external package to show a modal sheet.
      context: context,
      builder: (context) {
        return Material(
          // Wraps content to apply styling (like border radius).
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: SafeArea(
            // Ensures content doesn't overlap system UI (e.g., notches).
            top: false, // Allows content to go up to the top edge visually.
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Takes minimum vertical space needed.
              children: [
                // Drag handle
                Container(
                  // Visual drag indicator at the top of the modal.
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Responsive Grid for overflow items
                Flexible(
                  // Allows the grid to take up flexible space.
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ResponsiveGridList(
                      // UI Part: Grid for the hidden navigation items.
                      minItemWidth: 100, // each tile min width
                      minItemsPerRow: 2,
                      maxItemsPerRow: 4,
                      horizontalGridSpacing: 16,
                      verticalGridSpacing: 16,
                      shrinkWrap: true,
                      children: _overflowItems.map((item) {
                        // Maps overflow items to grid tiles.
                        final itemIndex = item['navIndex'] as int;
                        final isActive =
                            itemIndex ==
                            widget
                                .currentIndex; // Logic: Check if this overflow item is the current destination.

                        return GestureDetector(
                          onTap: () {
                            // Close the modal and then trigger navigation
                            Navigator.pop(context); // Closes the modal sheet.
                            widget.onTap(
                              itemIndex,
                            ); // Triggers navigation in the parent widget.
                          },
                          child: Column(
                            // Structure for the icon and label in the grid tile.
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // Container for the icon (to apply background/shadow).
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      isActive // UI Logic: Changes color if active.
                                      ? Colors.deepPurple.shade400
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: // UI Logic: Changes icon color if active.
                                  isActive
                                      ? Colors.white
                                      : Colors.black87,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                // The destination label.
                                item['title'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isActive // UI Logic: Changes text color if active.
                                      ? Colors.deepPurple
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Padding for navbar height
                SizedBox(
                  // Adds padding at the bottom of the modal.
                  height:
                      _kNavBarHeight +
                      MediaQuery.of(context)
                          .padding
                          .bottom, // Ensures the modal content clears the physical bottom bar.
                ),
              ],
            ),
          ),
        );
      },
    );

    // Reset the modal flag once the modal is closed
    if (mounted)
      setState(
        () => _isModalOpen = false,
      ); // Logic: Resets flag after modal dismissal.
  }

  /// Handles taps on the nav bar items, redirecting overflow taps to the modal.
  void _handleTap(BuildContext context, int index) {
    // Logic: Handles taps from the main nav bar items.
    if (index == maxVisibleTabs) {
      // Checks if the tapped index is the position of the "More" tab.
      // Tapped the "More" tab
      // NOTE: We don't check _isModalOpen because showMaterialModalBottomSheet
      // handles preventing duplicate modals if one is already open.
      _showOverflowModal(context); // Shows the overflow modal.
    } else {
      // Tapped a visible item
      widget.onTap(
        index,
      ); // Navigates directly if it's one of the visible tabs.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine visible items and the static "More" item
    final navBarItems = [
      ..._visibleItems,
      moreTab,
    ]; // Logic: Creates the final list of 4 items for the main bar (3 visible + More).

    // ***************************************************************
    // ** CORRECTED LOGIC **
    // The More tab is active ONLY if the current index is one of the
    // overflow indices (navIndex >= maxVisibleTabs).
    // It should NOT be active just because the modal is open.
    // ***************************************************************
    final isOverflowDestinationActive =
        widget.currentIndex >=
        maxVisibleTabs; // Logic: Checks if the currently selected screen is one of the hidden ones (index 3, 4, 5, etc.).

    return Container(
      // Main container for the bottom navigation bar.
      height: _kNavBarHeight,
      decoration: BoxDecoration(
        // Styling for the bar (background color and shadow).
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3), // Shadow pointing upwards.
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ), // Ensures items are slightly above the bottom edge.
        child: Row(
          // Arranges the items horizontally.
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Distributes space equally between items.
          children: navBarItems.asMap().entries.map((entry) {
            // Maps the 4 items (3 visible + 1 More) to NavBarItem widgets.
            final index =
                entry.key; // Position in the visible array (0, 1, 2, 3)
            final item = entry.value;
            final isMoreTab =
                item['navIndex'] == -1; // Logic: Identifies the "More" button.

            final bool
            isActive; // Logic: Determines the active state for styling.
            if (isMoreTab) {
              // The "More" tab is active only if an overflow destination is selected.
              isActive =
                  isOverflowDestinationActive; // Active if the current index is >= 3.
            } else {
              // A visible tab is active if it matches the current index AND
              // the current index is NOT an overflow index.
              isActive =
                  widget.currentIndex ==
                  item['navIndex']; // Active only if index matches (0, 1, or 2).
            }

            return NavBarItem(
              // Builds the individual tappable widget.
              icon: item['icon'] as IconData,
              label: item['title'] as String,
              isActive: isActive,
              onTap: () => _handleTap(
                context,
                index,
              ), // Calls the tap handler with its visible index (0, 1, 2, or 3).
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// NavBarItem (Individual navigation item)
// ----------------------------------------------------------------------

/// Represents a single, tappable item in the bottom navigation bar.
class NavBarItem extends StatelessWidget {
  // UI Part: The reusable structure for a single nav button.
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Darker color for active state, muted color for inactive state
    final color = isActive
        ? Colors.black
        : Colors.grey[500]; // UI Logic: Chooses color based on active state.
    return GestureDetector(
      // Makes the item tappable.
      onTap: onTap,
      child: Column(
        // Vertical stack for the icon and label.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: 22), // The item icon.
          Text(
            label, // The item label.
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isActive
                  ? FontWeight.bold
                  : FontWeight.normal, // UI Logic: Bolds text if active.
            ),
          ),
        ],
      ),
    );
  }
}
