// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';
// import 'package:final_project/features/bookmarks/presentation/models/collection.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<List<Collection>> fetchCollections() async {
//   final userId = FirebaseAuth.instance.currentUser?.uid;

//   if (userId == null) return [];

//   try {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('collections')
//         .get();

//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return Collection(
//         id: doc.id,
//         name: data['name'] ?? 'Untitled Collection',
//         bookmarks: (data['bookmarks'] as List<dynamic>? ?? []).map((bookmark) {
//           return Bookmark.fromMap(bookmark);
//         }).toList(),
//       );
//     }).toList();
//   } catch (e) {
//     print("Error fetching collections: $e");
//     return [];
//   }
// }
