// lib/repository/profile_repository.dart (Firestore Integration)

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management and dependency injection. Integration Part.
import 'package:cloud_firestore/cloud_firestore.dart'; // Imports the Firebase Firestore package for database interaction. Integration Part.
import '../models/profile_data.dart'; // Imports the ProfileData model for type-safe data handling. Logic Part.

// =========================================================================
// PROFILE REPOSITORY (Data Layer/Service)
// =========================================================================

/// [ProfileRepository] is responsible for all direct interactions with the Firestore database. // Documentation: Describes the repository's role as the data access layer.
/// It serves as the single source of truth for profile data. // Logic Part: Enforces separation of concerns (UI vs Data).
class ProfileRepository {
  // Defines the repository class. Logic Part.
  /// Defines the exact Firestore path (Collection: birjisInfo, Document: birjisInfo). // Integration Part: Specifies the hardcoded path to the data document.
  final DocumentReference _profileDoc = FirebaseFirestore
      .instance // Integration Part: Gets the main Firestore instance.
      .collection(
        'birjisInfo',
      ) // Integration Part: Specifies the 'birjisInfo' collection.
      .doc(
        'birjisInfo',
      ); // Integration Part: Specifies the 'birjisInfo' document within the collection.

  /// Fetches the entire profile document data from Firestore. // Documentation: Describes the method's purpose.
  ///
  /// Throws an exception if the document is not found or if there is a network/permission error. // Logic Part: Defines error handling behavior.
  Future<ProfileData> getProfileData() async {
    // Asynchronous method returning a Future of ProfileData.
    try {
      // Starts a try-catch block for robust error handling during the network request.
      final DocumentSnapshot snapshot = await _profileDoc
          .get(); // Integration Part: Executes the network call to fetch the document once.

      if (snapshot.exists && snapshot.data() != null) {
        // Logic Part: Checks if the document exists and contains data.
        // Cast data to the required Map structure.
        final Map<String, dynamic>
        data = // Logic Part: Safely casts the snapshot data to a Map<String, dynamic>.
            snapshot.data() as Map<String, dynamic>;

        // Convert the raw Firestore map into the type-safe Dart Model (ProfileData).
        return ProfileData.fromJson(
          data,
        ); // Logic Part: Uses the model's factory constructor for type-safe deserialization.
      } else {
        // Handle case where the document exists but is empty, or document path is wrong.
        throw Exception(
          'Profile document not found in Firestore.',
        ); // Logic Part: Throws a specific error if the document is missing.
      }
    } catch (e) {
      // Catches any exceptions thrown during the process (network, permission, casting).
      // Catch Firestore errors (e.g., permission denied, network issues)
      print(
        "Firestore Fetch Error: $e",
      ); // Debugging: Logs the specific error to the console.
      // Throw a user-friendly error that the UI can display.
      throw Exception(
        'Failed to connect to the profile database: $e',
      ); // Logic Part: Throws a clean error message back up to the UI layer.
    }
  }
}

// =========================================================================
// RIVERPOD INTEGRATION (Dependency Injection & State Management)
// =========================================================================

/// 1. [profileRepositoryProvider]: A [Provider] that manages the single instance of [ProfileRepository]. // Documentation: Describes the repository provider's role.
/// This is used for Dependency Injection (DI) to make the repository easily accessible and testable. // Integration Part: Standard Riverpod DI pattern.
final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(),
); // Integration Part: Creates and manages a single instance of ProfileRepository.

/// 2. [profileDataProvider]: A [FutureProvider] that handles the asynchronous fetching of [ProfileData]. // Documentation: Describes the data provider's role (fetching async data).
/// This provider holds the state of the data (Loading, Error, Data) and automatically // Integration Part: FutureProvider automatically handles the AsyncValue state.
/// refetches data when its dependencies (the repository) change.
final profileDataProvider = FutureProvider<ProfileData>((ref) async {
  // Defines the FutureProvider that resolves to ProfileData.
  // Read the repository instance using DI.
  final repo = ref.read(
    profileRepositoryProvider,
  ); // Integration Part: Accesses the repository instance from its provider.

  // Execute the data fetching function. Riverpod manages the result.
  return repo
      .getProfileData(); // Logic Part: Calls the repository method to start the asynchronous data fetch.
});
