import 'package:flutter/material.dart';

// CustomBottomNavBar separates bottom nav from page content
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // Active tab
  final Function(int) onTap; // Callback when tapped

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Fixed height
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3), // Shadow pointing up
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          NavBarItem(
            icon: Icons.person,
            label: 'Birjis',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          NavBarItem(
            icon: Icons.folder_open,
            label: 'Projects',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          NavBarItem(
            icon: Icons.star_border,
            label: 'Skills',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          NavBarItem(
            icon: Icons.mail,
            label: 'Contact',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          NavBarItem(
            icon: Icons.work,
            label: 'Experience',
            isActive: currentIndex == 4,
            onTap: () => onTap(4),
          ),
          NavBarItem(
            icon: Icons.download,
            label: 'Downloads',
            isActive: currentIndex == 5,
            onTap: () => onTap(5),
          ),
        ],
      ),
    );
  }
}

// Individual navigation item
class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive; // To color active tab
  final VoidCallback? onTap; // Detect tap

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF6A9DFF) : Colors.grey[500];
    return GestureDetector(
      onTap: onTap, // Handle tab tap
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color, size: 24), // Icon for tab
          Text(
            label,
            style: TextStyle(
              color: color, // Highlight if active
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
