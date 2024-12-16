import 'package:final_project/features/bookmarks/presentation/models/collection.dart';
import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onOpen;

  const CollectionCard({
    required this.collection,
    required this.onOpen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder, size: 48, color: Colors.teal),
            SizedBox(height: 8),
            Text(
              collection.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '${collection.bookmarks.length} bookmarks',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins-Light'),
            ),
          ],
        ),
      ),
    );
  }
}
