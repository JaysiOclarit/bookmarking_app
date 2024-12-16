import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/bookmarks/presentation/pages/edit_bookmark_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:final_project/core/utils/metadata_fetcher.dart'; // Import the metadata fetcher
import '../../../features/bookmarks/presentation/models/bookmark.dart'; // Adjust the path based on your project structure

// Function to submit a new bookmark
Future<void> submitBookmark({
  required String url, // The URL to be bookmarked
  required List<String>? tags, // The tags for the bookmark
  required BuildContext context, // The context for showing SnackBars
  required VoidCallback
      onLoadingStart, // Callback to indicate loading has started
  required VoidCallback onLoadingEnd, // Callback to indicate loading has ended
  required VoidCallback
      onSuccess, // Callback to execute on successful bookmark addition
}) async {
  // Check if the URL is empty
  if (url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('URL cannot be empty')), // Show error message
    );
    return; // Exit the function if URL is empty
  }

  // Indicate loading
  onLoadingStart();

  try {
    // Fetch metadata from the provided URL
    final metadata = await fetchMetadata(url);

    // Stop loading
    onLoadingEnd();

    // Check if metadata was successfully fetched
    if (metadata != null) {
      // Create a new bookmark object from the fetched metadata
      Bookmark bookmark = Bookmark(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Unique ID based on current time
        title: metadata['title'] ??
            'Untitled', // Use fetched title or default to 'Untitled'
        url: metadata['url'] ?? url, // Use fetched URL or the provided URL
        image: metadata['image'] ??
            'https://via.placeholder.com/150', // Use fetched image or a placeholder
        description: metadata['description'] ??
            'No description', // Use fetched description or default text
        date: DateFormat('MM/dd/yyyy').format(DateTime.now()),
        tags: tags ??
            [], // Use provided tags or default to an empty list // Format the current date
      );

      // Save the bookmark to Firestore under the user's bookmarks collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('bookmarks')
          .doc(bookmark.id)
          .set(bookmark.toMap()); // Convert bookmark to a map for Firestore

      // Show success toast notification
      Fluttertoast.showToast(
        msg: "Bookmark added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Call the success callback
      onSuccess();
    } else {
      // Show error message if metadata fetching failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch metadata')),
      );
    }
  } catch (e) {
    // Stop loading in case of an error
    onLoadingEnd();
    // Show error message with the exception details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding bookmark: $e')),
    );
  }
}

// Function to delete a bookmark by its ID
Future<void> deleteBookmark(String bookmarkId, BuildContext context) async {
  try {
    // Delete the bookmark document from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bookmarks')
        .doc(bookmarkId)
        .delete();

    // Show success toast notification
    Fluttertoast.showToast(
      msg: "Bookmark deleted successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } catch (e) {
    // Show error message if deletion fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting bookmark: $e')),
    );
  }
}

Future<void> deleteBookmarkInCollection({
  required String collectionId,
  required String bookmarkId,
  required BuildContext context,
}) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User not authenticated")),
    );
    return;
  }

  try {
    // Reference to the specific collection document
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('collections')
        .doc(collectionId);

    // Fetch the current collection document
    final collectionSnapshot = await collectionRef.get();

    if (!collectionSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Collection does not exist")),
      );
      return;
    }

    // Retrieve the bookmarks array from the document
    List<dynamic> bookmarks = collectionSnapshot.data()?['bookmarks'] ?? [];

    // Remove the bookmark with the given ID
    bookmarks.removeWhere((bookmark) => bookmark['id'] == bookmarkId);

    // Update the collection document with the modified bookmarks array
    await collectionRef.update({'bookmarks': bookmarks});

    Fluttertoast.showToast(
      msg: "Bookmark deleted successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting bookmark: $e')),
    );
  }
}

// Fetch bookmark by ID
Future<Bookmark?> fetchBookmarkById({
  required BuildContext context,
  required String bookmarkId,
}) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookmarkId)
        .get();

    if (doc.exists) {
      return Bookmark.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark not found')),
      );
      return null;
    }
  } catch (e) {
    throw Exception('Error fetching bookmark: $e');
  }
}

// Update bookmark
Future<void> updateBookmark({
  required BuildContext context,
  required String bookmarkId,
  required Bookmark updatedBookmark,
}) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookmarkId)
        .update(updatedBookmark.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark updated successfully!')),
    );
  } catch (e) {
    throw Exception('Error updating bookmark: $e');
  }
}

Future<void> updateBookmarkInCollection({
  required String collectionId,
  required String bookmarkId,
  required Bookmark updatedBookmark,
  required BuildContext context,
}) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User not authenticated")),
    );
    return;
  }

  try {
    // Reference to the specific collection document
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('collections')
        .doc(collectionId);

    // Fetch the current collection document
    final collectionSnapshot = await collectionRef.get();

    if (!collectionSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Collection does not exist")),
      );
      return;
    }

    // Retrieve the bookmarks array from the document
    List<dynamic> bookmarks = collectionSnapshot.data()?['bookmarks'] ?? [];

    // Find the bookmark within the collection and update it
    final index =
        bookmarks.indexWhere((bookmark) => bookmark['id'] == bookmarkId);

    if (index != -1) {
      // Update the bookmark in the collection
      bookmarks[index] = updatedBookmark.toMap();

      // Update the collection document with the modified bookmarks array
      await collectionRef.update({'bookmarks': bookmarks});

      // Update the bookmark in the user's main bookmarks collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(bookmarkId)
          .update(updatedBookmark.toMap());

      // Show success toast notification
      Fluttertoast.showToast(
        msg: "Bookmark updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bookmark not found in this collection")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating bookmark: $e')),
    );
  }
}

//
Future<bool> navigateToEditBookmark({
  required BuildContext context,
  required String bookmarkId,
  required String collection,
  required Function onEditSuccess,
}) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditBookmarkPage(
        bookmarkId: bookmarkId,
        collection: collection,
      ),
    ),
  );

  if (result == true) {
    onEditSuccess(); // Callback to refresh state
    return true;
  }
  return false;
}
