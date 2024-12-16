import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';

class Collection {
  final String id;
  final String name;
  final List<Bookmark> bookmarks;
  final DateTime? createdAt;

  Collection({
    required this.id,
    required this.name,
    this.bookmarks = const [],
    this.createdAt,
  });

  factory Collection.fromMap(Map<String, dynamic> map, String id) {
    return Collection(
      id: id,
      name: map['name'] as String? ?? 'Untitled Collection',
      bookmarks: (map['bookmarks'] as List<dynamic>? ?? []).map((bookmark) {
        return Bookmark.fromMap(bookmark as Map<String, dynamic>);
      }).toList(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bookmarks': bookmarks.map((bookmark) => bookmark.toMap()).toList(),
      if (createdAt != null)
        'createdAt': Timestamp.fromDate(
            createdAt!), // Convert DateTime to Firestore Timestamp
    };
  }
}
