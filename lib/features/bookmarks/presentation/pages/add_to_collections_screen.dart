import 'package:final_project/core/utils/collections/repository/collection_repository.dart';
import 'package:final_project/core/widgets/my_button.dart';
import 'package:final_project/features/bookmarks/presentation/models/bookmark.dart';
import 'package:final_project/features/bookmarks/presentation/models/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddToCollectionScreen extends StatefulWidget {
  final Bookmark bookmark;

  const AddToCollectionScreen({super.key, required this.bookmark});

  @override
  _AddToCollectionScreenState createState() => _AddToCollectionScreenState();
}

class _AddToCollectionScreenState extends State<AddToCollectionScreen> {
  final CollectionRepository _repository = CollectionRepository();
  List<Collection> collections = [];
  String? _selectedCollectionId; // Selected collection ID
  String? _selectedAction; // Selected action: Copy or Move

  bool get isAddEnabled =>
      _selectedCollectionId != null && _selectedAction != null;

  @override
  void initState() {
    super.initState();
    _repository.loadCollections();
  }

  // Add or move bookmark logic
  Future<void> addToCollection() async {
    if (_selectedCollectionId == null || _selectedAction == null) return;

    try {
      if (_selectedAction == "Copy") {
        // Add bookmark to target collection
        await _repository.addBookmarkToCollection(
            collectionId: _selectedCollectionId!,
            bookmark: widget.bookmark,
            context: context);
      } else if (_selectedAction == "Move") {
        // Move bookmark: remove from original collection and add to target
        await _repository.moveBookmark(
          bookmark: widget.bookmark,
          originalCollectionId: "bookmarks", // Original collection ID
          targetCollectionId: _selectedCollectionId!,
        );
      }

      // Show success feedback
      Fluttertoast.showToast(
        msg: "Bookmark ${_selectedAction!.toLowerCase()}ed successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pop(context); // Close the screen
    } catch (e) {
      _showError("Failed to ${_selectedAction!.toLowerCase()} bookmark: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, style: TextStyle(color: Colors.red))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              "Add to collections",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins-Bold',
              ),
            ),
            Text(
              widget.bookmark.title, // Display the bookmark title
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            MyButton(
              textColor: Colors.white,
              buttonText: 'Create new collection',
              onPressed: _createNewCollection,
              backgroundColor: Colors.teal,
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Collection>>(
                stream: _repository.loadCollections(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error loading collections: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No collections available.'));
                  }

                  final collections = snapshot.data!;

                  return ListView.builder(
                    itemCount: collections.length,
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return RadioListTile<String>(
                        value: collection.id,
                        groupValue: _selectedCollectionId,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCollectionId = newValue;
                          });
                        },
                        activeColor: Colors.teal,
                        title: Text(
                          collection.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Copy'),
                Text("or", style: TextStyle(color: Colors.black, fontSize: 16)),
                _buildActionButton("Move"),
              ],
            ),
            SizedBox(height: 26),
            MyButton(
              textColor: Colors.white,
              buttonText: 'Add to Collection(s)',
              onPressed: () {
                if (isAddEnabled) {
                  addToCollection();
                }
              },
              backgroundColor: isAddEnabled ? Colors.teal : Colors.grey[800],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String action) {
    final isSelected = _selectedAction == action;
    return MyButton(
      height: 50,
      width: 150,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          _selectedAction = action;
        });
      },
      backgroundColor: isSelected ? Colors.teal : Colors.grey[800],
      buttonText: action,
    );
  }

  Future<void> _createNewCollection() async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create Collection"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter collection name"),
        ),
        actions: [
          MyButton(
            textColor: Colors.black,
            buttonText: 'Cancel',
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.grey[350],
          ),
          SizedBox(
            height: 20,
          ),
          MyButton(
            textColor: Colors.white,
            buttonText: 'Create',
            backgroundColor: Colors.teal,
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                try {
                  await _repository.createCollection(name);
                  Navigator.pop(context);
                  _repository.loadCollections(); // Refresh collections
                } catch (e) {
                  _showError("Failed to create collection: $e");
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
