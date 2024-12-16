import 'package:final_project/core/utils/collections/util/collections_handler.dart';
import 'package:final_project/core/widgets/my_button.dart';
import 'package:final_project/core/widgets/my_textfield.dart';

import 'package:flutter/material.dart';

class AddCollectionPage extends StatefulWidget {
  const AddCollectionPage({
    super.key,
  });

  @override
  State<AddCollectionPage> createState() => _AddCollectionPageState();
}

class _AddCollectionPageState extends State<AddCollectionPage> {
  final TextEditingController _collectionNameController =
      TextEditingController();

  bool _isLoading = false;

  void _handleSubmitCollection() {
    final collectionName = _collectionNameController.text.trim();

    submitCollection(
      collectionName: collectionName,
      context: context,
      onLoadingStart: () {
        setState(() {
          _isLoading = true;
        });
      },
      onLoadingEnd: () {
        setState(() {
          _isLoading = false;
        });
      },
      onSuccess: () {
        _collectionNameController
            .clear(); // Clear the collection name input after success
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Collection",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Information Box
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF008080).withOpacity(0.54),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Did you know?",
                            style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "You can categorize your bookmarks making it easier to organize and find them later.",
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // URL Input Field
              MyCustomTextField(
                controller: _collectionNameController,
                labelText: "Collection name",
                hintText: "e.g. Places to visit",
              ),
              const SizedBox(height: 70),
              // Buttons
              Column(
                children: [
                  GradientElevatedButton(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF008080), // 0%
                        Color(0xFF2D9696), // 34%
                        Color(0xFF59ACAC), // 71%
                        Color(0xFF85C2C2), // 100%
                      ],
                      stops: [0.0, 0.34, 0.71, 1.0], // Define the stops
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    buttonText: "Create new collection",
                    textColor: Theme.of(context).colorScheme.surface,
                    onPressed: _handleSubmitCollection,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
