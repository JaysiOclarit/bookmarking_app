import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/features/bookmarks/presentation/models/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CollectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _getUserId() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print("Retrieved user ID: $userId");
    return userId;
  }

  Future<void> createCollection(String name) async {
    final userId = _getUserId();
    if (userId == null) {
      print("Error: User not logged in");
      throw Exception("User not logged in");
    }

    if (name.trim().isEmpty) {
      print("Error: Collection name cannot be empty");
      throw Exception("Collection name cannot be empty");
    }

    final collectionId = const Uuid().v4();
    final collectionData = {
      'id': collectionId,
      'name': name.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'bookmarks': [],
    };

    print(
        "Creating collection with ID: $collectionId and data: $collectionData");

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('collections')
          .doc(collectionId)
          .set(collectionData);
      print("Collection created successfully");
    } catch (e) {
      print("Error creating collection: $e");
      throw Exception("Failed to create collection: $e");
    }
  }

  userId() {
    final userId = _getUserId();
    if (userId == null) {
      print("Error: User not logged in");
      throw Exception("User not logged in");
    }
  }

  Future<List<Collection>> fetchCollections() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print("No user ID found, returning empty collection list");
      return [];
    }

    print("Fetching collections for user ID: $userId");

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('collections')
          .get();

      print("Collections fetched successfully: ${snapshot.docs.length} found");

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Collection(
          id: doc.id,
          name: data['name'] ?? 'Untitled Collection',
          bookmarks:
              (data['bookmarks'] as List<dynamic>? ?? []).map((bookmark) {
            return Bookmark.fromMap(bookmark);
          }).toList(),
        );
      }).toList();
    } catch (e) {
      print("Error fetching collections: $e");
      return [];
    }
  }

  Stream<List<Collection>> loadCollections() {
    final userId = _getUserId();
    if (userId == null) {
      print("Error: User not logged in");
      throw Exception("User not logged in");
    }
    print("Loading collections for user ID: $userId");
    try {
      return FirebaseFirestore.instance
          .collection('users') // Go into the `users` collection
          .doc(userId) // Access the logged-in user's document
          .collection('collections') // Access the user's `collections`
          .orderBy('createdAt', descending: true) // Optional ordering
          .snapshots()
          .map((querySnapshot) {
        print("Collections loaded: ${querySnapshot.docs.length} found");
        return querySnapshot.docs.map((doc) {
          return Collection.fromMap(doc.data(), doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error loading collections: $e');
      rethrow; // Re-throw the error so the caller can handle it
    }
  }

  // Fetch a bookmark directly from the "bookmarks" collection
  Future<Bookmark?> getBookmarkFromBookmarks(String bookmarkId) async {
    print("Fetching bookmark from bookmarks collection with ID: $bookmarkId");
    try {
      final docSnapshot =
          await _firestore.collection('bookmarks').doc(bookmarkId).get();

      if (!docSnapshot.exists) {
        print("Error: Bookmark not found");
        throw Exception('Bookmark not found');
      }
      print("Bookmark fetched successfully: ${docSnapshot.data()}");

      return Bookmark.fromMap(docSnapshot.data()!);
    } catch (e) {
      print("Error fetching bookmark: $e");
      throw Exception('Error fetching bookmark: $e');
    }
  }

  // Fetch a bookmark from the "collections" collection
  Future<Bookmark?> getBookmarkFromCollections({
    required String collectionName,
    required String bookmarkId,
  }) async {
    print(
        "Fetching bookmark from collection '$collectionName' with ID: $bookmarkId");
    try {
      final docRef = _firestore.collection('collections').doc(collectionName);
      final collectionDoc = await docRef.get();

      if (!collectionDoc.exists) {
        print("Error: Collection not found");
        throw Exception('Collection not found');
      }

      // Assume bookmarks are stored as an array in the collection document
      final bookmarksData =
          (collectionDoc.data()?['bookmarks'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>();

      if (bookmarksData == null || bookmarksData.isEmpty) {
        print("Error: No bookmarks found in this collection");
        throw Exception('No bookmarks found in this collection');
      }

      // Find the specific bookmark by ID
      final bookmarkData = bookmarksData.firstWhere(
        (bookmark) => bookmark['id'] == bookmarkId,
        orElse: () => {},
      );

      if (bookmarkData.isEmpty) {
        print(
            "Bookmark with ID: $bookmarkId not found in collection '$collectionName'");
        return null; // Bookmark not found
      }
      print("Bookmark fetched successfully: $bookmarkData");
      return Bookmark.fromMap(bookmarkData);
    } catch (e) {
      print("Error fetching bookmark: $e");
      throw Exception('Error fetching bookmark: $e');
    }
  }

  // Update a bookmark in the "bookmarks" collection
  Future<void> updateBookmarkInBookmarks({
    required String bookmarkId,
    required Bookmark updatedBookmark,
  }) async {
    print("Updating bookmark in bookmarks collection with ID: $bookmarkId");
    try {
      await _firestore
          .collection('bookmarks')
          .doc(bookmarkId)
          .update(updatedBookmark.toMap());
      print("Bookmark updated successfully");
    } catch (e) {
      print("Error updating bookmark: $e");
      throw Exception('Error updating bookmark: $e');
    }
  }

  /// Fetch a specific bookmark from a given collection.
  Future<Bookmark?> fetchBookmarkFromCollection({
    required String collectionId,
    required String bookmarkId,
  }) async {
    final userId = _getUserId();
    if (userId == null) {
      print("Error: User not logged in");
      throw Exception("User not logged in");
    }
    print(
        "Fetching bookmark from collection ID: $collectionId with bookmark ID: $bookmarkId");
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('collections')
          .doc(collectionId);

      final collectionSnapshot = await docRef.get();

      if (!collectionSnapshot.exists) {
        print("Error: Collection not found");
        throw Exception("Collection not found");
      }

      final data = collectionSnapshot.data();
      final bookmarks = (data?['bookmarks'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      final bookmarkData = bookmarks.firstWhere(
          (bookmark) => bookmark['id'] == bookmarkId,
          orElse: () => {});

      if (bookmarkData.isNotEmpty) {
        print("Bookmark fetched successfully: $bookmarkData");
        return Bookmark.fromMap(bookmarkData);
      } else {
        print(
            "Bookmark with ID: $bookmarkId not found in collection ID: $collectionId");
        return null;
      }
    } catch (e) {
      print("Failed to fetch bookmark: $e");
      throw Exception("Failed to fetch bookmark: $e");
    }
  }

  // Update a bookmark in the "collections" collection
  Future<void> updateBookmarkInCollections({
    required String collectionName,
    required String bookmarkId,
    required Bookmark updatedBookmark,
  }) async {
    print(
        "Updating bookmark in collection '$collectionName' with ID: $bookmarkId");
    try {
      final docRef = _firestore.collection('collections').doc(collectionName);
      final collectionDoc = await docRef.get();

      if (!collectionDoc.exists) {
        print("Error: Collection not found");
        throw Exception('Collection not found');
      }

      // Get existing bookmarks and update the specific one
      final bookmarksData =
          (collectionDoc.data()?['bookmarks'] as List<dynamic>?)
                  ?.cast<Map<String, dynamic>>() ??
              [];

      final updatedBookmarks = bookmarksData.map((bookmark) {
        if (bookmark['id'] == bookmarkId) {
          print("Updating bookmark data: ${updatedBookmark.toMap()}");
          return updatedBookmark.toMap(); // Replace with updated bookmark data
        }
        return bookmark;
      }).toList();

      // Update the Firestore document with the modified bookmarks array
      await docRef.update({'bookmarks': updatedBookmarks});
      print("Bookmark updated successfully in collection '$collectionName'");
    } catch (e) {
      print("Error updating bookmark: $e");
      throw Exception('Error updating bookmark: $e');
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    final userId = _getUserId();
    if (userId == null) {
      throw Exception("User not logged in");
    }

    try {
      final collectionRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('collections')
          .doc(collectionId);

      // Fetch collection data before deletion to handle cascading deletes
      final collectionSnapshot = await collectionRef.get();
      if (collectionSnapshot.exists) {
        final bookmarks =
            collectionSnapshot.data()?['bookmarks'] as List<dynamic>? ?? [];
        // Handle cascade deletion if necessary (optional)
      }

      await collectionRef.delete();
    } catch (e) {
      throw Exception("Failed to delete collection: $e");
    }
  }

  Future<void> addBookmarkToCollection({
    required String
        collectionId, // The ID of the collection to which the bookmark will be added
    required Bookmark bookmark, // The bookmark to be added
    required BuildContext context, // The context for showing SnackBars
  }) async {
    try {
      // Fetch the collection document from Firestore
      DocumentSnapshot collectionDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('collections')
          .doc(collectionId)
          .get();

      if (collectionDoc.exists) {
        // Convert the document data to a Collection object
        Collection collection = Collection.fromMap(
            collectionDoc.data() as Map<String, dynamic>, collectionId);

        // Create a new bookmark with the same data as the original bookmark
        Bookmark newBookmark = Bookmark(
          // Assuming Bookmark has properties like title, url, etc.
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: bookmark.title,
          url: bookmark.url,
          image: bookmark.image,
          description: bookmark.description,
          date: bookmark.date,
          // Add other properties as needed
        );

        // Add the new bookmark to the collection's bookmarks list
        collection.bookmarks.add(newBookmark);

        // Update the collection document in Firestore with the new bookmarks list
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('collections')
            .doc(collectionId)
            .update(collection.toMap());

        // Show success toast notification
        Fluttertoast.showToast(
          msg: "Bookmark added to collection successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Show error message if the collection does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collection not found')),
        );
      }
    } catch (e) {
      // Show error message if any error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bookmark to collection: $e')),
      );
    }
  }

  Future<void> moveBookmark({
    required Bookmark bookmark,
    required String
        originalCollectionId, // This is the ID of the "bookmarks" collection
    required String
        targetCollectionId, // This is the ID of the target collection in "collections"
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User  not logged in");

    try {
      // Step 1: Fetch the bookmark document from the "bookmarks" collection
      DocumentReference originalBookmarkRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(bookmark.id); // Assuming bookmark has an 'id' property

      DocumentSnapshot originalBookmarkSnapshot =
          await originalBookmarkRef.get();
      if (!originalBookmarkSnapshot.exists) {
        throw Exception("Original bookmark not found");
      }

      // Step 2: Delete the bookmark from the "bookmarks" collection
      await originalBookmarkRef.delete();

      // Step 3: Add the bookmark to the target collection in "collections"
      DocumentReference targetCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('collections')
          .doc(targetCollectionId);

      // Fetch the target collection document to ensure it exists
      DocumentSnapshot targetCollectionSnapshot =
          await targetCollectionRef.get();
      if (!targetCollectionSnapshot.exists) {
        throw Exception("Target collection not found");
      }

      // Add the bookmark to the target collection's bookmarks list
      await targetCollectionRef.update({
        'bookmarks': FieldValue.arrayUnion(
            [bookmark.toMap()]) // Assuming bookmark has a toMap() method
      });

      print("Bookmark moved successfully from 'bookmarks' to 'collections'");
    } catch (e) {
      throw Exception("Failed to move bookmark: $e");
    }
  }

  // Fetch a single bookmark by collection name and bookmark ID
  Future<Bookmark?> getBookmark({
    required String collectionName,
    required String bookmarkId,
  }) async {
    try {
      // Ensure user is authenticated
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Initialize a variable to hold the bookmark data
      Map<String, dynamic>? bookmarkData;

      // 1. Check the `bookmarks` collection for the bookmark
      final bookmarkDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(bookmarkId)
          .get();

      if (bookmarkDoc.exists) {
        bookmarkData = bookmarkDoc.data();
      }

      // 2. If not found in `bookmarks`, check the `collections` collection
      if (bookmarkData == null) {
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('collections')
            .doc(collectionName);

        final collectionDoc = await docRef.get();
        if (!collectionDoc.exists) {
          throw Exception('Collection not found');
        }

        final bookmarksData =
            (collectionDoc.data()?['bookmarks'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>();

        if (bookmarksData == null || bookmarksData.isEmpty) {
          throw Exception('No bookmarks found in this collection');
        }

        // Find the specific bookmark by ID
        bookmarkData = bookmarksData.firstWhere(
          (bookmark) => bookmark['id'] == bookmarkId,
          orElse: () => {}, // Fallback empty map
        );

        if (bookmarkData.isEmpty || !bookmarkData.containsKey('id')) {
          return null; // Bookmark not found
        }
      }

      // 3. Convert the bookmark data into a Bookmark object and return
      return Bookmark.fromMap(bookmarkData);
    } catch (e) {
      print('Error fetching bookmark: $e'); // For debugging
      throw Exception('Error fetching bookmark: $e');
    }
  }

  // Update a bookmark in the specified collection
  Future<void> updateBookmark({
    required String collectionName,
    required String bookmarkId,
    required Bookmark updatedBookmark,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // 1. Attempt to update in `bookmarks` collection
      final bookmarkDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(bookmarkId);

      final bookmarkDoc = await bookmarkDocRef.get();
      if (bookmarkDoc.exists) {
        await bookmarkDocRef.update(updatedBookmark.toMap());
        print('Bookmark updated in bookmarks collection.');
        return;
      }
      // 2. If not in `bookmarks`, update in the `collections` collection
      final collectionDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('collections')
          .doc(collectionName);

      final collectionDoc = await collectionDocRef.get();
      if (!collectionDoc.exists) {
        throw Exception('Collection not found.');
      }

      final bookmarksData =
          (collectionDoc.data()?['bookmarks'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>();

      if (bookmarksData == null || bookmarksData.isEmpty) {
        throw Exception('No bookmarks found in this collection.');
      }

      // Find and update the bookmark in the array
      final bookmarkIndex =
          bookmarksData.indexWhere((bookmark) => bookmark['id'] == bookmarkId);
      if (bookmarkIndex == -1) {
        throw Exception('Bookmark not found in collection.');
      }

      bookmarksData[bookmarkIndex] = updatedBookmark.toMap();

      // Update the collection with the modified bookmarks array
      await collectionDocRef.update({'bookmarks': bookmarksData});
      print('Bookmark updated in collections.');
    } catch (e) {
      print('Error updating bookmark: $e');
      throw Exception('Error updating bookmark: $e');
    }
  }
}
