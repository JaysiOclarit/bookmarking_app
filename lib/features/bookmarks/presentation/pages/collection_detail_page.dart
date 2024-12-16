// import 'package:flutter/material.dart';
// import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';
// import 'package:final_project/features/bookmarks/presentation/widgets/bookmark/bookmark_card.dart';

// class CollectionDetailPage extends StatelessWidget {
//   final String collectionName;
//   final List<Bookmark> bookmarks;

//   const CollectionDetailPage({
//     super.key,
//     required this.collectionName,
//     required this.bookmarks,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(collectionName),
//       ),
//       body: _buildBookmarkList(),
//     );
//   }

//   Widget _buildBookmarkList() {
//     return ListView.builder(
//       itemCount: bookmarks.length,
//       itemBuilder: (context, index) {
//         return BookmarkCard(
//           bookmark: bookmarks[index],
//           onBookmarkUpdated: () {
//             // Handle bookmark update
//           },
//           onBookmarkDeleted: () {
//             // Handle bookmark deletion
//           },
//         );
//       },
//     );
//   }
// }
