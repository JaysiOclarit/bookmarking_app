import 'package:final_project/core/utils/bookmarks/bookmark_provider.dart';
import 'package:final_project/core/utils/collections/repository/collection_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/bookmark.dart';

class EditBookmarkPage extends StatefulWidget {
  final String bookmarkId;
  final VoidCallback? onBookmarkUpdated;
  final String collection;

  const EditBookmarkPage({
    super.key,
    required this.bookmarkId,
    this.collection = '',
    this.onBookmarkUpdated,
  });

  @override
  State<EditBookmarkPage> createState() => _EditBookmarkPageState();
}

class _EditBookmarkPageState extends State<EditBookmarkPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _imageUrl = '';
  String _url = '';
  bool _isLoading = true;

  late final CollectionRepository _collectionRepository;

  @override
  void initState() {
    super.initState();
    _collectionRepository = CollectionRepository();
    print(
        'EditBookmarkPage initialized with bookmarkId: ${widget.bookmarkId} and collection: ${widget.collection}');
    _fetchBookmarkInCollection();
  }

  Future<void> _fetchBookmarkInCollection() async {
    print('Fetching bookmark...');
    print('Collection Name: ${widget.collection}');
    print('Bookmark ID: ${widget.bookmarkId}');
    try {
      final bookmark = await _collectionRepository.getBookmark(
        collectionName: widget.collection,
        bookmarkId: widget.bookmarkId,
      );

      if (bookmark == null) {
        _showErrorSnackBar('Bookmark not found');
        print('Bookmark not found for id: ${widget.bookmarkId}');
        Navigator.pop(context);
        return;
      }

      setState(() {
        _titleController.text = bookmark.title;
        _descriptionController.text = bookmark.description;
        _imageUrl = bookmark.image;
        _url = bookmark.url;
        _isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar('Error fetching bookmark: $e');
      print('Error fetching bookmark: $e');

      print('Exception details: ${e.toString()}');
      print('Stack trace: ${StackTrace.current}');
      Navigator.pop(context);
    }
  }

  Future<void> _updateBookmark() async {
    print('Updating bookmark...');
    try {
      final updatedBookmark = Bookmark(
        id: widget.bookmarkId,
        title: _titleController.text,
        url: _url,
        image: _imageUrl,
        description: _descriptionController.text,
        date: DateFormat('MM/dd/yyyy').format(DateTime.now()),
      );

      await _collectionRepository.updateBookmark(
        collectionName: widget.collection,
        bookmarkId: widget.bookmarkId,
        updatedBookmark: updatedBookmark,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark updated successfully!')),
      );

      widget.onBookmarkUpdated?.call();
      Navigator.pop(context, true);
    } catch (e) {
      print('Error updating bookmark: $e');
      _showErrorSnackBar('Error updating bookmark: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    print('Error: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(_imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Title',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateBookmark,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
