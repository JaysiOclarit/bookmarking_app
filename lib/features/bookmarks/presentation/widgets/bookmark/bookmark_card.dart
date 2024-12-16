import 'package:final_project/features/bookmarks/presentation/pages/add_to_collections_screen.dart';
import 'package:final_project/features/bookmarks/presentation/pages/edit_bookmark_page.dart';
import 'package:final_project/core/utils/bookmarks/bookmark_handler.dart';
import 'package:flutter/material.dart';
import '../../models/bookmark.dart';
import '../../../../../core/utils/url_launcher.dart';

class BookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback onBookmarkUpdated;
  final VoidCallback onBookmarkDeleted;
  final bool isInCollection; // NEW FLAG
  final Function(String bookmarkId) deleteCallback; // Flexible delete
  final VoidCallback onEdit;

  const BookmarkCard({
    required this.bookmark,
    required this.onBookmarkUpdated,
    required this.onBookmarkDeleted,
    required this.deleteCallback, // Pass dynamic delete logic
    required this.onEdit, // Add this line

    this.isInCollection = false, // Defaults to false (Bookmarks page)
    super.key,
  });

  void addToCollection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddToCollectionScreen(bookmark: bookmark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bookmark Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                bookmark.image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Date
                  Text(
                    bookmark.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.pin_drop, color: Colors.teal, size: 16),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Tooltip(
                          message: bookmark.url,
                          child: GestureDetector(
                            onTap: () {
                              launchURL(bookmark.url, context);
                            },
                            child: Text(
                              bookmark.url, // URL
                              style: TextStyle(
                                fontFamily: 'Poppins-Light',
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        " • ${bookmark.date}", // Date
                        style: TextStyle(
                          fontFamily: 'Poppins-Light',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tags
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (bookmark.tags != null && bookmark.tags!.isNotEmpty)
                          ? bookmark.tags!.join(', ')
                          : 'No tags available', // Fallback if tags is null or empty
                      style: TextStyle(
                        fontFamily: 'Poppins-Light',
                        fontSize: 12,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Handle favorite action
                            },
                            icon: const Icon(Icons.star_border),
                            color: Colors.teal,
                          ),
                          IconButton(
                            onPressed: () {
                              addToCollection(context);
                            },
                            icon: const Icon(Icons.playlist_add),
                            color: Colors.teal,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle more options
                          _showBottomSheet(context);
                        },
                        icon: const Icon(Icons.more_vert),
                        color: Colors.grey[700],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure it doesn't take the whole screen
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Other options",
                style: TextStyle(fontSize: 18, fontFamily: 'Poppins-Bold'),
              ),
              Text(
                bookmark.title,
                style: TextStyle(fontSize: 15, fontFamily: 'Poppins-Light'),
              ),
              const SizedBox(height: 8),
              _buildBottomSheetOption(
                icon:
                    Icons.edit, // Sets the icon for the option to an edit icon.
                text:
                    "Edit bookmark", // The text label for the option displayed in the bottom sheet.
                color:
                    Colors.black, // Sets the color of the text/icon to black.
                onTap: () async {
                  // Defines the action to take when the option is tapped. It's an asynchronous function.
                  Navigator.pop(
                      context); // Closes the bottom sheet when the option is tapped.

                  // Navigates to the EditBookmarkPage, passing the bookmark ID to edit the specific bookmark.
                  onEdit();
                  // Checks if the result returned from the EditBookmarkPage is true.
                },
              ),
              _buildBottomSheetOption(
                icon: Icons.share,
                text: "Share bookmark",
                color: Colors.black,
                onTap: () {
                  print("Share bookmark tapped");
                },
              ),
              _buildBottomSheetOption(
                icon: Icons.label,
                text: "Manage tags",
                color: Colors.black,
                onTap: () {
                  print("Manage tags tapped");
                },
              ),
              _buildBottomSheetOption(
                icon: Icons.delete,
                text: "Delete bookmark",
                color: Colors.red,
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  await deleteCallback(
                      bookmark.id); // Use dynamic deletion logic
                  onBookmarkDeleted(); // Trigger UI update// Trigger the callback to update the list
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String text,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color, fontFamily: 'Poppins-Regular'),
      ),
      onTap: onTap,
    );
  }
}
