class Bookmark {
  String id;
  String title;
  String url;
  String image;
  String description;
  final String date;
  List<String>? tags; // Add tags field

  Bookmark({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.description,
    required this.date,
    this.tags, // Include tags in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'image': image,
      'description': description,
      'date': date,
      'tags': tags, // Add tags to the map
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      tags: map['tags'] != null
          ? List<String>.from(map['tags'])
          : null, // Retrieve tags from the map
    );
  }
}
