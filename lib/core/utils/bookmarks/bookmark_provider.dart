import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/bookmarks/presentation/models/bookmark.dart';

class BookmarkProvider with ChangeNotifier {
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => _bookmarks;

  Future<void> fetchBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .get();

      _bookmarks =
          snapshot.docs.map((doc) => Bookmark.fromMap(doc.data())).toList();
      notifyListeners(); // Notify listeners to rebuild UI
    } catch (e) {
      debugPrint('Error fetching bookmarks: $e');
    }
  }

  Future<void> updateBookmark(
      String collection, String bookmarkId, Bookmark updatedBookmark) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(collection) // Use the collection parameter
        .doc(bookmarkId)
        .set(updatedBookmark
            .toMap()); // Assuming you have a toMap method in your Bookmark model
  }
}
