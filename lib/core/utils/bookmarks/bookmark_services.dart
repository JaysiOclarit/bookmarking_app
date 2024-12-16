import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/bookmarks/presentation/models/bookmark.dart';

Future<List<Bookmark>> fetchBookmarks() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .get();

    return snapshot.docs.map((doc) => Bookmark.fromMap(doc.data())).toList();
  }

  return [];
}
