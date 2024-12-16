import 'package:final_project/core/utils/bookmarks/bookmark_handler.dart';
import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';
import 'package:final_project/features/bookmarks/presentation/pages/edit_bookmark_page.dart';
import 'package:final_project/features/bookmarks/presentation/widgets/bookmark/bookmark_card.dart';
import 'package:flutter/material.dart';

class BookmarkListScreen extends StatefulWidget {
  final String collectionName;
  final List<Bookmark> bookmarks;
  final String collectionId;

  const BookmarkListScreen({
    required this.collectionName,
    required this.bookmarks,
    required this.collectionId,
    super.key,
  });

  @override
  State<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  late List<Bookmark> _bookmarks;

  @override
  void initState() {
    super.initState();
    _bookmarks = widget.bookmarks;
  }

  void _refreshBookmarks() {
    setState(() {
      // Logic to refresh bookmarks, such as re-fetching from the database
    });
  }

  Future<void> _navigateToEditPage(Bookmark bookmark) async {
    final bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookmarkPage(
          bookmarkId: bookmark.id,
          collection: widget.collectionId,
          onBookmarkUpdated: _refreshBookmarks,
        ),
      ),
    );

    // Refresh the bookmarks if the edit was successful
    if (isUpdated == true) {
      _refreshBookmarks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
      ),
      body: _bookmarks.isEmpty
          ? Center(
              child: Text(
                "No bookmarks found",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = _bookmarks[index];
                return BookmarkCard(
                  key: ValueKey(bookmark.id), // Add Key for optimization
                  bookmark: bookmark,
                  onBookmarkDeleted: () => deleteBookmarkInCollection,
                  onBookmarkUpdated: () =>
                      _navigateToEditPage(bookmark), // Navigate to edit page
                  deleteCallback: (bookmarkId) async {
                    await deleteBookmarkInCollection(
                      // Logic for deleting a bookmark
                      collectionId: widget.collectionId,
                      bookmarkId: bookmarkId,
                      context: context,
                    );
                  },
                  onEdit: () =>
                      _navigateToEditPage(bookmark), // Pass the edit action
                );
              },
            ),
    );
  }
}
