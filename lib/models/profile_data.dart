// lib/models/profile_data.dart
/// This file defines the Dart models for profile data, ensuring type safety // Documentation: Purpose of the file is to define data structures (models).
/// and providing a structured way to parse data retrieved from Firestore. // Logic Part: Models provide the structure needed to safely parse JSON/Map data.

// =========================================================================
// SECTION DATA MODEL
// =========================================================================

/// [SectionData] represents the content for a single portfolio card (e.g., Projects, Skills). // Documentation: Describes the model's function (a single card's data).
/// It maps directly to the nested objects within the 'sections' map in the Firestore document. // Logic Part: Explains the direct relationship between the model and the data source structure.
class SectionData {
  // Defines the SectionData class. Logic Part.
  final String
  title; // Data field: The title of the section (e.g., "My Projects").

  /// Stores the string representation of the Flutter Icon (e.g., 'Icons.folder_open'). // Documentation: Explains why the icon is stored as a string.
  /// This string is later converted to an IconData object in the UI layer. // UI Logic: Notes that conversion is handled in the presentation layer.
  final String icon; // Data field: The string name of the icon.
  final String description; // Data field: The descriptive text for the section.

  SectionData({
    // Constructor to initialize a SectionData object. Logic Part.
    required this.title, // Requires the title field.
    required this.icon, // Requires the icon string field.
    required this.description, // Requires the description field.
  });

  /// Factory constructor to create a [SectionData] instance from a JSON map. // Documentation: Explains the factory method's role (deserialization).
  factory SectionData.fromJson(Map<String, dynamic> json) {
    // Static method for creating an instance from a map (Firestore data).
    return SectionData(
      // Returns a new SectionData instance.
      title:
          json['title'] as String? ??
          'N/A', // Logic Part: Safely extracts 'title', casts it to String, and uses 'N/A' if null (null coalescing).
      icon:
          json['icon'] as String? ??
          'Icons.error', // Logic Part: Safely extracts 'icon', uses 'Icons.error' if null.
      description: // Logic Part: Safely extracts 'description', uses a default message if null.
          json['description'] as String? ?? 'Description not available.',
    );
  }
}

// =========================================================================
// PROFILE DATA MODEL (Main Document)
// =========================================================================

/// [ProfileData] represents the entire content of the 'birjisInfo' Firestore document. // Documentation: Describes the model's primary role (the root document).
/// It contains main profile details and a map of all portfolio sections. // Logic Part: Outlines the main fields contained in the document.
class ProfileData {
  // Defines the ProfileData class. Logic Part.
  final String name; // Data field: The user's name.
  final String role; // Data field: The user's professional role.
  final String introduction; // Data field: The introductory text.
  final String imageUrl; // Data field: URL for the profile picture.

  /// Stores all portfolio section data, keyed by the section name (e.g., 'projects', 'skills'). // Logic Part: The structure for nested data.
  final Map<String, SectionData>
  sections; // Data field: A map holding multiple SectionData objects.

  ProfileData({
    // Constructor to initialize a ProfileData object.
    required this.name, // Requires the name field.
    required this.role, // Requires the role field.
    required this.introduction, // Requires the introduction field.
    required this.imageUrl, // Requires the image URL field.
    required this.sections, // Requires the map of sections.
  });

  /// Factory constructor to map the entire Firestore document data into a [ProfileData] object. // Documentation: Explains the factory method's role for the main document.
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    // Static method for deserializing the entire document map.
    // 1. Get the raw 'sections' map from Firestore
    final Map<String, dynamic>
    rawSections = // Logic Part: Extracts the nested map for sections.
        json['sections'] as Map<String, dynamic>? ??
        {}; // Safely casts to a map, defaulting to an empty map if null/missing.

    // 2. Process the raw map into a Map<String, SectionData> by calling
    //    SectionData.fromJson for every entry. This ensures deep type safety. // Logic Part: Explains the deep conversion process.
    final Map<String, SectionData> parsedSections = rawSections.map(
      // Iterates through the raw sections map.
      (key, value) => // For each key-value pair in the raw map.
      MapEntry(
        key,
        SectionData.fromJson(value as Map<String, dynamic>),
      ), // Calls the nested SectionData.fromJson for conversion.
    );

    // 3. Return the fully formed ProfileData object, using null coalescing (??)
    //    for safe access, even if some fields are missing in Firestore. // Logic Part: Final step of creating the root model instance.
    return ProfileData(
      // Returns the new ProfileData instance.
      name:
          json['name'] as String? ??
          'Default Name', // Logic Part: Safely extracts 'name' with a default fallback.
      role:
          json['role'] as String? ??
          'Default Role', // Logic Part: Safely extracts 'role' with a default fallback.
      introduction: // Logic Part: Safely extracts 'introduction' with a default fallback.
          json['introduction'] as String? ?? 'Welcome to the portfolio.',
      imageUrl:
          json['profileImageUrl'] as String? ??
          '', // Logic Part: Safely extracts 'profileImageUrl' with an empty string fallback.
      sections:
          parsedSections, // Passes the fully parsed and type-safe sections map.
    );
  }
}
