import 'package:cloud_firestore/cloud_firestore.dart'; // Integration: Imports Firestore classes like DocumentSnapshot for database interaction.
import 'package:flutter/material.dart'; // UI/Logic: Imports Flutter's core UI components and types like IconData and Color.

// =========================================================================
// 0. UTILITY FUNCTIONS & MAPS
// =========================================================================

/// Static map to look up IconData from a string name stored in Firestore. // Logic/Integration: Defines the purpose of the map.
/// NOTE: Add ALL icon names used in your Firestore documents here. // Logic: Instruction to keep this map synchronized with the database.
final Map<String, IconData> iconNameMap = {
  // Logic: Declares a map to translate string names (from Firestore) to Dart/Flutter IconData objects.
  // Key Feature Icons: // UI/Integration: Category header for readability.
  'workspace_premium': Icons
      .workspace_premium, // Logic/UI: Maps the string 'workspace_premium' to the specific Flutter Icon.
  'integration_instructions':
      Icons.integration_instructions, // Logic/UI: Maps string to IconData.
  'check_circle': Icons.check_circle, // Logic/UI: Maps string to IconData.
  'task_alt': Icons.task_alt, // Logic/UI: Maps string to IconData.
  'verified': Icons.verified, // Logic/UI: Maps string to IconData.
  // Skill Icons: // UI/Integration: Category header for readability.
  'data_usage': Icons.data_usage, // Logic/UI: Maps string to IconData.
  'storage': Icons.storage, // Logic/UI: Maps string to IconData.
  'devices_other': Icons.devices_other, // Logic/UI: Maps string to IconData.
  'local_fire_department':
      Icons.local_fire_department, // Logic/UI: Maps string to IconData.
  'terminal': Icons.terminal, // Logic/UI: Maps string to IconData.
  'code': Icons
      .code, // Logic/UI: Maps string to IconData, used as a robust fallback for skills.
  'error': Icons
      .error, // Logic/UI: Maps string to IconData, used as a robust fallback for features.
};

/// Utility function to convert a hex string (e.g., '0xFF5C6BC0') to a Flutter Color object. // Logic: Describes the function's purpose.
Color colorFromHexString(String hexString) {
  // Logic: Starts the function definition.
  if (hexString.isEmpty)
    return const Color(
      0xFFCCCCCC,
    ); // Logic/UI: Returns a default gray color if the string is empty, preventing errors.

  // Ensure the string has '0x' prefix and is clean // Logic: Comment explaining the string cleanup.
  final String cleanHex = hexString.startsWith('0x')
      ? hexString
      : '0x$hexString'; // Logic: Ensures the hex string has the '0x' prefix required for Dart/Flutter parsing.

  try {
    // Logic: Starts error handling for potentially malformed strings.
    final int colorValue = int.parse(
      // Logic: Parses the hex string into a standard 32-bit integer.
      cleanHex.replaceAll(
        '0x',
        '',
      ), // Logic: Removes the '0x' prefix before parsing.
      radix: 16, // Logic: Specifies base 16 (hexadecimal) for parsing.
    );
    return Color(
      colorValue,
    ); // Logic/UI: Creates and returns the Flutter Color object from the integer value.
  } catch (e) {
    // Logic: Catches any errors during the parsing process.
    // Fallback if parsing fails (e.g., bad string format) // Logic: Comment explaining the fallback.
    return const Color(
      0xFFCCCCCC,
    ); // Logic/UI: Returns a default color upon error.
  }
}

// =========================================================================
// 1. PROJECT MODEL (Main Project List Item)
// =========================================================================

class Project {
  // Logic: Defines the data model for a high-level project list item.
  final String title; // Logic: Field for the project title.
  final String description; // Logic: Field for the brief description/summary.
  final String imageUrl; // Logic: Field for the project's main image URL.
  final String
  detailsRoute; // Logic: Field for the navigation route (e.g., '/project1').
  final int order; // Logic: Field to control the display order.
  final String
  id; // Logic: Field for the Firestore document ID, used to fetch details.

  Project({
    // Logic: Constructor to initialize the fields.
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.detailsRoute,
    required this.order,
    required this.id,
  });

  factory Project.fromFirestore(DocumentSnapshot doc) {
    // Logic/Integration: Factory constructor to convert a Firestore document into a Project object.
    final data =
        doc.data()
            as Map<
              String,
              dynamic
            >?; // Integration: Extracts the document data as a Map.

    if (data == null) {
      // Logic: Checks if data exists.
      throw Exception(
        "Project document data is null.",
      ); // Logic: Throws an error if data is missing.
    }

    return Project(
      // Logic: Constructs and returns the Project object.
      id: doc.id, // Integration: Extracts the Firestore document ID.
      title:
          data['title'] as String? ??
          'No Title', // Integration/Logic: Retrieves 'title' with a null check and fallback.
      description:
          data['description'] as String? ??
          'No Description', // Integration/Logic: Retrieves 'description' with a fallback.
      imageUrl:
          data['imageUrl'] as String? ??
          'https://via.placeholder.com/350x200', // Integration/Logic: Retrieves 'imageUrl' with a fallback.
      detailsRoute:
          data['route'] as String? ??
          '/home', // Integration/Logic: Retrieves 'route' with a fallback.
      order:
          (data['order'] as num?)?.toInt() ??
          999, // Integration/Logic: Retrieves 'order', handles numeric types, and provides a fallback.
    );
  }
}

// =========================================================================
// 2. KEY FEATURE MODEL (Nested Item)
// =========================================================================

class KeyFeature {
  // Logic: Defines the data model for an individual key feature.
  final IconData icon; // Logic/UI: Field for the feature icon.
  final String heading; // Logic: Field for the feature title/heading.
  final String
  description; // Logic: Field for the feature detailed description.
  final Color color; // Logic/UI: Field for the feature's accent color.
  final int order; // Logic: Field to control the display order.

  KeyFeature({
    // Logic: Constructor.
    required this.icon,
    required this.heading,
    required this.description,
    required this.color,
    required this.order,
  });

  factory KeyFeature.fromMap(Map<String, dynamic> data) {
    // Logic/Integration: Factory to convert a map (nested in ProjectDetails) into a KeyFeature object.
    // Icon name in Firestore might be stored as 'iconName' // Integration: Comment on the expected key.
    final iconName =
        data['iconName'] as String? ??
        'error'; // Integration/Logic: Retrieves 'iconName' string with fallback.
    final iconData =
        iconNameMap[iconName] ??
        Icons
            .error; // Logic/UI: Looks up IconData from the map, using Icons.error as the ultimate fallback.

    // NOTE: Using 'title' for heading based on your structure // Logic: Comment specific to the user's Firestore schema.
    return KeyFeature(
      // Logic: Constructs and returns the KeyFeature object.
      icon: iconData, // Logic/UI: Assigns the looked-up IconData.
      heading:
          data['title'] as String? ??
          'Feature Title', // Integration/Logic: Retrieves 'title' for the heading.
      description:
          data['description'] as String? ??
          'Feature Description', // Integration/Logic: Retrieves 'description'.
      color: colorFromHexString(
        data['color'] as String? ?? '0xFFCCCCCC',
      ), // Integration/Logic: Retrieves color string and converts it using the utility function.
      order:
          (data['order'] as num?)?.toInt() ??
          99, // Integration/Logic: Retrieves 'order' and provides a fallback.
    );
  }
}

// =========================================================================
// 3. SKILL MODEL (Nested Item)
// =========================================================================

class Skill {
  // Logic: Defines the data model for an individual skill used in the project.
  final IconData icon; // Logic/UI: Field for the skill icon.
  final String title; // Logic: Field for the skill name (e.g., 'React').
  final String
  experience; // Logic: Field for the experience level (e.g., '3 Years').
  final String
  badgeText; // Logic: Field for the colored badge text (e.g., 'IMPROVED').
  final Color badgeColor; // Logic/UI: Field for the badge's accent color.
  final int order; // Logic: Field to control the display order.

  Skill({
    // Logic: Constructor.
    required this.icon,
    required this.title,
    required this.experience,
    required this.badgeText,
    required this.badgeColor,
    required this.order,
  });

  factory Skill.fromMap(Map<String, dynamic> data) {
    // Logic/Integration: Factory to convert a map (nested in ProjectDetails) into a Skill object.
    final iconName =
        data['iconName'] as String? ??
        'code'; // Integration/Logic: Retrieves 'iconName' with fallback.
    final iconData =
        iconNameMap[iconName] ??
        Icons
            .code; // Logic/UI: Looks up IconData, using Icons.code as the ultimate fallback.

    return Skill(
      // Logic: Constructs and returns the Skill object.
      icon: iconData, // Logic/UI: Assigns the looked-up IconData.
      title:
          data['title'] as String? ??
          'Skill Title', // Integration/Logic: Retrieves 'title'.
      experience:
          data['experience'] as String? ??
          'N/A', // Integration/Logic: Retrieves 'experience'.
      badgeText:
          data['badgeText'] as String? ??
          'NA', // Integration/Logic: Retrieves 'badgeText'.
      badgeColor: colorFromHexString(
        data['badgeColor'] as String? ?? '0xFFCCCCCC',
      ), // Integration/Logic: Retrieves and converts the badge color string.
      order:
          (data['order'] as num?)?.toInt() ??
          99, // Integration/Logic: Retrieves 'order'.
    );
  }
}

// =========================================================================
// 4. PROJECT DETAILS MODEL (Wraps all nested data)
// =========================================================================

class ProjectDetails {
  // Logic: Defines the main data model for a project's detailed view.
  final String
  fullDescription; // Logic: Field for the extended project description.
  final String
  websiteUrl; // Logic: Field for the link to the external project website.
  final List<String>
  screenshotUrls; // Logic: Field for a list of screenshot image URLs.
  final List<KeyFeature>
  keyFeatures; // Logic: Field for a list of KeyFeature objects.
  final List<Skill> skillsUsed; // Logic: Field for a list of Skill objects.

  ProjectDetails({
    // Logic: Constructor.
    required this.fullDescription,
    required this.websiteUrl,
    required this.screenshotUrls,
    required this.keyFeatures,
    required this.skillsUsed,
  });

  factory ProjectDetails.fromFirestore(DocumentSnapshot doc) {
    // Logic/Integration: Factory constructor for the ProjectDetails document.
    final data =
        doc.data()
            as Map<
              String,
              dynamic
            >?; // Integration: Extracts the document data.

    if (data == null) {
      // Logic: Checks for data existence.
      throw Exception(
        "Project details document data is null.",
      ); // Logic: Throws error if data is missing.
    }

    // =====================================================================
    // Key Feature Parsing (Robust FIX for List or Map structures)
    // =====================================================================

    final dynamic keyFeaturesDynamic =
        data['keyFeatures']; // Integration: Retrieves the keyFeatures field, using 'dynamic' to handle unknown type.
    List<KeyFeature> features =
        []; // Logic: Initializes an empty list to store parsed features.

    if (keyFeaturesDynamic is Map) {
      // Logic: Checks if the data structure is a Map (Firestore's default indexed map).
      // Handles the array-like Map structure (keys '0', '1', etc.) // Logic: Comment explaining the structure being handled.
      final Map<String, dynamic> keyFeaturesMap =
          keyFeaturesDynamic
              as Map<
                String,
                dynamic
              >; // Logic: Casts the dynamic object to a Map.
      features = keyFeaturesMap.entries.map((entry) {
        // Logic: Iterates over the Map entries.
        return KeyFeature.fromMap(
          entry.value as Map<String, dynamic>,
        ); // Logic: Converts each entry's value (the feature map) into a KeyFeature object.
      }).toList(); // Logic: Converts the resulting iterable to a List.
    } else if (keyFeaturesDynamic is List) {
      // Logic: Checks if the data structure is a List (common on Web or after array transformations).
      // Handles a simple List/Array structure (resolves the JSArray error) // Logic: Comment on the structure and error fix.
      features = keyFeaturesDynamic.map((item) {
        // Logic: Iterates over the List items.
        return KeyFeature.fromMap(
          item as Map<String, dynamic>,
        ); // Logic: Converts each List item (the feature map) into a KeyFeature object.
      }).toList(); // Logic: Converts the resulting iterable to a List.
    }
    features.sort(
      (a, b) => a.order.compareTo(b.order),
    ); // Logic: Sorts the list of features based on the 'order' field.

    // =====================================================================
    // Skills Used Parsing
    // =====================================================================
    final List<dynamic> skillsArray =
        data['skillsUsed'] as List<dynamic>? ??
        []; // Integration/Logic: Retrieves 'skillsUsed' as a List, with a fallback to an empty list.
    final List<Skill> skills = skillsArray.map((item) {
      // Logic: Maps each item in the skills list.
      return Skill.fromMap(
        item as Map<String, dynamic>,
      ); // Logic: Converts each item map into a Skill object.
    }).toList(); // Logic: Converts the result to a List.
    skills.sort(
      (a, b) => a.order.compareTo(b.order),
    ); // Logic: Sorts the list of skills based on the 'order' field.

    // =====================================================================
    // Screenshot Parsing
    // =====================================================================
    final List<dynamic> screenshotsArray =
        data['screenshots'] as List<dynamic>? ??
        []; // Integration/Logic: Retrieves 'screenshots' as a List of dynamic, with a fallback.
    final List<String> screenshots = screenshotsArray
        .map((url) => url.toString())
        .toList(); // Logic: Converts each item to a string URL and puts it into a List.

    return ProjectDetails(
      // Logic: Constructs and returns the final ProjectDetails object.
      fullDescription:
          data['fullDescriptionText'] as String? ??
          'No full description available.', // Integration/Logic: Retrieves and assigns 'fullDescriptionText'.
      websiteUrl:
          data['websiteUrl'] as String? ??
          'https://www.google.com', // Integration/Logic: Retrieves and assigns 'websiteUrl'.
      screenshotUrls: screenshots, // Logic: Assigns the parsed screenshot list.
      keyFeatures:
          features, // Logic: Assigns the parsed and sorted key features list.
      skillsUsed: skills, // Logic: Assigns the parsed and sorted skills list.
    );
  }
}
