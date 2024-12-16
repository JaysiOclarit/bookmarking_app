import 'package:final_project/core/widgets/my_button.dart';
import 'package:final_project/core/widgets/my_textfield.dart';
import 'package:final_project/core/utils/bookmarks/bookmark_handler.dart';
import 'package:flutter/material.dart';

class AddBookmarkPage extends StatefulWidget {
  const AddBookmarkPage({
    super.key,
  });

  @override
  State<AddBookmarkPage> createState() => _AddBookmarkPageState();
}

class _AddBookmarkPageState extends State<AddBookmarkPage> {
  final TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;

  void _handleSubmitBookmark() {
    final url = _urlController.text.trim();

    submitBookmark(
      url: url,
      tags: [],
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
        _urlController.clear();
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
                "Add Bookmark",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-Regular'),
              ),
              const SizedBox(height: 8),
              const Text(
                "Paste a URL to add a bookmark",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Poppins-Light'),
              ),
              const SizedBox(height: 16),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "You can share links straight to the Mark-it app to add bookmarks even faster.",
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Add Learn More logic here
                                },
                                child: const Text(
                                  "Learn More",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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
                controller: _urlController,
                labelText: "URL",
                hintText: "e.g. https://www.facebook.com/",
              ),
              const SizedBox(height: 70),
              // Buttons
              Column(
                children: [
                  MyButton(
                    backgroundColor: Color(0xFF658888),
                    buttonText: "Add to Collections",
                    textColor: Color(0xFF004C4C),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 25),
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
                    buttonText: "Add to my bookmarks",
                    textColor: Theme.of(context).colorScheme.surface,
                    onPressed: _handleSubmitBookmark,
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
