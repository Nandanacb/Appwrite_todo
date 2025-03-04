import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;

  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "6736e59600111983e972";
  static const databaseId = "6736e6360030b46985d3";
  static const collectionId = "6736e68c000d4447620f";

  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Document>> getTasks() async {
    try {
      final result = await databases.listDocuments(
        collectionId: collectionId,
        databaseId: databaseId,
      );
      return result.documents;
    } catch (e) {
      print("Error loading task :$e");
      rethrow;
    }
  }

  Future<Document> addTask(String title) async {
    try {
      final documentId = ID.unique();

      final result = await databases.createDocument(
        collectionId: collectionId,
        databaseId: databaseId,
        data: {
          'task': title,
          'completed': false,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print("Error creating task :$e");
      rethrow;
    }
  }

  Future<Document> updateTaskStatus(String documentId, bool completed) async {
    try {
      final result = await databases.updateDocument(
        collectionId: collectionId,
        documentId: documentId,
        data: {'completed': completed},
        databaseId: databaseId,
      );
      return result;
    } catch (e) {
      print("Error updating task status:$e");
      rethrow;
    }
  }

  Future<void> deleteTask(String documentId) async {
    try {
      await databases.deleteDocument(
        collectionId: collectionId,
        documentId: documentId,
        databaseId: databaseId,
      );
    } catch (e) {
      print("Error deleting task:$e");
      rethrow;
    }
  }
}
