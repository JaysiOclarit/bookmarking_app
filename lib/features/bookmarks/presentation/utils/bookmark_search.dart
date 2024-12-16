import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';

class BookmarkSearch {
  // This method searches through a list of bookmarks based on a query string.
  static List<Bookmark> search(List<Bookmark> bookmarks, String query) {
    // If the query is empty, return the original list of bookmarks.
    if (query.isEmpty) return bookmarks;

    // Normalize the query by converting it to lowercase and trimming whitespace.
    final normalizedQuery = query.toLowerCase().trim();

    // Filter the bookmarks based on the search criteria.
    return bookmarks.where((bookmark) {
      // Comprehensive search strategies to match bookmarks.
      return _matchExact(
              bookmark.title, normalizedQuery) || // Check for exact title match
          _matchContains(bookmark.title,
              normalizedQuery) || // Check if title contains the query
          _matchStartsWith(bookmark.title,
              normalizedQuery) || // Check if title starts with the query
          _matchExact(
              bookmark.url, normalizedQuery) || // Check for exact URL match
          _matchContains(
              bookmark.url, normalizedQuery); // Check if URL contains the query
    }).toList(); // Convert the filtered results back to a list.
  }

  // Helper method to check for an exact match of the query in the given text.
  static bool _matchExact(String? text, String query) {
    return text?.toLowerCase() ==
        query; // Compare the normalized text with the query.
  }

  // Helper method to check if the query is contained within the given text.
  static bool _matchContains(String? text, String query) {
    return text?.toLowerCase().contains(query) ??
        false; // Return true if the text contains the query.
  }

  // Helper method to check if any word in the text starts with the query.
  static bool _matchStartsWith(String? text, String query) {
    if (text == null) return false; // Return false if the text is null.
    // Split the text into words and check if any word starts with the query.
    return text.toLowerCase().split(' ').any((word) => word.startsWith(query));
  }
}
