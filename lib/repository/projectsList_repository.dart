import 'package:cloud_firestore/cloud_firestore.dart'; // Integration: Imports Firestore classes needed for database interaction (e.g., DocumentSnapshot, FirebaseFirestore).
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Integration/Logic: Imports Riverpod for dependency injection and state management (providers).
import '../models/projectsList_data.dart'; // Logic: Imports the data models (Project, ProjectDetails) needed by this repository.

// 1. Define the Repository class for Projects // Logic: Defines a class to encapsulate all data fetching logic, isolating it from the UI.
class ProjectListRepository {
  // Logic: Class definition starts.
  final _projectsCollection = FirebaseFirestore.instance.collection(
    // Integration: Declares a private field to hold the reference to the main 'projectsList' Firestore collection.
    'projectsList', // Integration: Specifies the exact name of the top-level collection in Firestore.
  ); // Integration: Closes the collection reference assignment.

  // Method to fetch all projects, sorted by the 'order' field // Logic: Describes the function's purpose (getting the main list).
  Future<List<Project>> fetchAllProjects() async {
    // Logic: Function definition; returns a Future list of Project objects.
    try {
      // Logic: Starts a try-catch block for error handling during asynchronous database operation.
      final querySnapshot =
          await _projectsCollection // Integration: Fetches documents from the 'projectsList' collection.
              .orderBy(
                'order',
                descending: false,
              ) // Integration: Specifies the sort order based on the 'order' field.
              .get(); // Integration: Executes the query and waits for the result (QuerySnapshot).

      return querySnapshot
          .docs // Logic: Accesses the list of documents from the snapshot.
          .map(
            (doc) => Project.fromFirestore(doc),
          ) // Logic: Converts each Firestore document (doc) into a Project model using the factory constructor.
          .toList(); // Logic: Converts the resulting iterable into a final List<Project>.
    } on FirebaseException catch (e) {
      // Logic: Catches exceptions specific to Firebase operations.
      print(
        'Firebase Error fetching projects: $e',
      ); // Logic: Logs the specific Firebase error.
      rethrow; // Logic: Rethrows the error to be handled by the Riverpod provider or the UI.
    } catch (e) {
      // Logic: Catches any other general exceptions.
      print('Error fetching projects: $e'); // Logic: Logs the general error.
      rethrow; // Logic: Rethrows the error.
    }
  }

  // METHOD: Fetch the detailed data for a specific project ID // Logic: Describes the function's purpose (getting detailed data for one project).
  Future<ProjectDetails> fetchProjectDetails(String projectId) async {
    // Logic: Function definition; takes a projectId string and returns a Future ProjectDetails object.
    try {
      // Logic: Starts a try-catch block for error handling.
      // Path: /projectList/{projectId}/details/description // Integration: Comment indicating the nested document path.
      final docRef =
          _projectsCollection // Integration: Starts from the main collection reference.
              .doc(
                projectId,
              ) // Integration: Selects the specific project document using the ID.
              .collection(
                'details',
              ) // Integration: Selects the 'details' subcollection.
              .doc(
                'description',
              ); // Integration: Selects the specific 'description' document containing the details data.

      final docSnapshot = await docRef
          .get(); // Integration: Executes the document fetch operation and waits for the snapshot.

      if (!docSnapshot.exists) {
        // Logic: Checks if the details document was found.
        // Return a default, empty object if the details document is missing // Logic: Comment explaining the fallback logic.
        return ProjectDetails(
          // Logic: Returns a safe, empty ProjectDetails object instead of throwing an error.
          fullDescription:
              'Details for this project are currently unavailable.', // Logic: Provides a default message.
          websiteUrl:
              'https://www.google.com', // Logic: Provides a safe default URL.
          screenshotUrls: [], // Logic: Empty list placeholder.
          keyFeatures: [], // Logic: Empty list placeholder.
          skillsUsed: [], // Logic: Empty list placeholder.
        ); // Logic: Closes the default ProjectDetails object.
      }

      return ProjectDetails.fromFirestore(
        docSnapshot,
      ); // Logic: Converts the fetched document snapshot into a ProjectDetails model object.
    } on FirebaseException catch (e) {
      // Logic: Catches Firebase-specific exceptions.
      print(
        'Firebase Error fetching project details: $e',
      ); // Logic: Logs the specific Firebase error.
      rethrow; // Logic: Rethrows the error.
    } catch (e) {
      // Logic: Catches general exceptions.
      print(
        'Error fetching project details: $e',
      ); // Logic: Logs the general error.
      rethrow; // Logic: Rethrows the error.
    }
  }
}

// 2. Define the Riverpod providers // Logic: Section header for Riverpod state management.

// Provider for the ProjectListRepository instance // Logic: Describes the simple provider.
final projectListRepositoryProvider = Provider((ref) {
  // Logic: Defines a standard Riverpod Provider for the Repository class.
  return ProjectListRepository(); // Logic: Returns a new instance of the repository, making it available throughout the app.
}); // Logic: Closes the provider definition.

// FutureProvider to expose the list of projects // Logic: Describes the asynchronous provider for the main list.
final projectsFutureProvider = FutureProvider<List<Project>>((ref) async {
  // Logic: Defines a FutureProvider that will hold the asynchronous state (loading, error, data) of the list of projects.
  final repo = ref.watch(
    projectListRepositoryProvider,
  ); // Logic: Gets the instance of the repository using the repository provider.
  return repo
      .fetchAllProjects(); // Logic: Calls the asynchronous fetch method and returns its result to the FutureProvider.
}); // Logic: Closes the provider definition.

// FutureProvider: Family provider to fetch details for a specific project ID // Logic: Describes the parameter-based provider.
final projectDetailsFutureProvider = // Logic: Defines the provider.
FutureProvider.family<ProjectDetails, String>((ref, projectId) async {
  // Logic: Defines a Family FutureProvider, parameterized by a String (projectId), returning Future<ProjectDetails>.
  final repo = ref.watch(
    projectListRepositoryProvider,
  ); // Logic: Gets the repository instance.
  return repo.fetchProjectDetails(
    projectId,
  ); // Logic: Calls the method, passing the projectId parameter received by the family provider.
}); // Logic: Closes the provider definition.
