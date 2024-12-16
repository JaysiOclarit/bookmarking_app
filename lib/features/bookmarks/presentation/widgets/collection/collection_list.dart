// import 'package:final_project/features/bookmarks/presentation/models/collection.dart';
// import 'package:final_project/features/bookmarks/presentation/widgets/collection/bookmark_list_screen.dart';
// import 'package:final_project/features/bookmarks/presentation/widgets/collection/collection_card.dart';
// import 'package:flutter/material.dart';

// class CollectionListScreen extends StatelessWidget {
//   final List<Collection> collections;

//   const CollectionListScreen({required this.collections, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Collections')),
//       body: collections.isEmpty
//           ? Center(
//               child: Text(
//                 "No collections found",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                   fontFamily: 'Poppins-Regular',
//                 ),
//               ),
//             )
//           : GridView.builder(
//               padding: EdgeInsets.all(8),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//               ),
//               itemCount: collections.length,
//               itemBuilder: (context, index) {
//                 final collection = collections[index];
//                 return CollectionCard(
//                   collection: collection,
//                   onOpen: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BookmarkListScreen(
//                           collectionId: collection.id,
//                           collectionName: collection.name,
//                           bookmarks: collection.bookmarks,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
