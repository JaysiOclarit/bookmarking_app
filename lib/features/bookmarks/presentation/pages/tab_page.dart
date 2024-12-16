import 'package:final_project/core/utils/bookmarks/bookmark_handler.dart';
import 'package:final_project/core/utils/collections/repository/collection_repository.dart';
import 'package:final_project/features/bookmarks/presentation/pages/add_collection_page.dart';
import 'package:final_project/features/bookmarks/presentation/utils/bookmark_search.dart';
import 'package:final_project/features/bookmarks/presentation/widgets/bookmark/bookmark_card.dart';
import 'package:final_project/features/bookmarks/presentation/widgets/collection/bookmark_list_screen.dart';
import 'package:final_project/features/bookmarks/presentation/widgets/collection/collection_card.dart';
import 'package:final_project/features/bookmarks/presentation/models/collection.dart';

import 'package:final_project/features/bookmarks/presentation/pages/edit_bookmark_page.dart';
import 'package:final_project/core/utils/bookmarks/bookmark_services.dart';

import 'package:flutter/material.dart';
import 'add_bookmark_page.dart';
import '../../../../core/widgets/my_button.dart';
import '../models/bookmark.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({
    super.key,
    this.initialTabIndex = 0,
    this.metadata,
  });

  final int initialTabIndex; // Optional: Specify the initial tab index
  final Map<String, String>? metadata; // Metadata passed from AddBookmarkPage

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  List<Bookmark> bookmarks = []; // List to store bookmarks
  List<Bookmark> filteredBookmarks = []; // New list for filtered bookmarks
  List<Collection> collections = []; // List to store collections
  bool isLoading = true; // Track loading state
  bool isSearchExpanded = false; // Track the state of the search bar
  bool hasSearched = false; // Track if a search has been performed
  final CollectionRepository _collectionRepository = CollectionRepository();

  @override
  void initState() {
    super.initState();
    if (widget.metadata != null) {
      bookmarks.add(Bookmark.fromMap(widget.metadata!));
    }
    _loadBookmarks();
    loadCollectionsWithBookmarks();
  }

  void _addBookmark(Map<String, String> bookmarkData) {
    setState(() {
      bookmarks.add(Bookmark.fromMap(bookmarkData));
    });
  }

  void addBookmark(BuildContext context) async {
    final newBookmark = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookmarkPage(),
      ),
    );

    if (newBookmark != null) {
      print("Adding bookmark: $newBookmark");
      _addBookmark(newBookmark); // Add the new bookmark to the list
    } else {
      print("No bookmark received");
    }
  }

  void _searchBookmarks(String query) {
    setState(() {
      hasSearched = true;
      if (query.isEmpty) {
        filteredBookmarks = List.from(bookmarks);
      } else {
        filteredBookmarks = bookmarks.where((bookmark) {
          return bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
              bookmark.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void toggleSearch() {
    setState(() {
      isSearchExpanded = !isSearchExpanded;
    });
  }

  Future<void> loadCollectionsWithBookmarks() async {
    try {
      final fetchedCollections = await _collectionRepository.fetchCollections();
      setState(() {
        collections = fetchedCollections;
        print('Collections loaded: ${collections.length}');
      });
    } catch (e) {
      print('Error loading collections: $e');
    }
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedBookmarks = await fetchBookmarks();
      setState(() {
        bookmarks = fetchedBookmarks;
        filteredBookmarks = fetchedBookmarks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching bookmarks: $e");
    }
  }

  void addCollection(BuildContext context) async {
    final newCollectionName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCollectionPage(),
      ),
    );

    if (newCollectionName != null && newCollectionName.isNotEmpty) {
      try {
        await _collectionRepository.createCollection(newCollectionName);
        loadCollectionsWithBookmarks();
      } catch (e) {
        print('Error creating collection: $e');
      }
    } else {
      print("No collection created");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialTabIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mark-it',
            style: TextStyle(fontFamily: 'Poppins-Bold'),
          ),
          bottom: TabBar(
            labelStyle: const TextStyle(fontFamily: 'Poppins-Medium'),
            tabs: const [
              Tab(text: 'Bookmark'),
              Tab(text: 'Collections'),
              Tab(text: 'Archived'),
            ],
            indicatorColor: Colors.teal,
            labelColor: Theme.of(context).colorScheme.inverseSurface,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        body: TabBarView(
          children: [
            isLoading
                ? _buildLoadingState()
                : bookmarks.isEmpty
                    ? _buildEmptyState(context)
                    : _buildBookmarksList(),
            Center(
              child: isLoading
                  ? _buildLoadingState()
                  : collections.isEmpty
                      ? _buildEmptyStateCollection(context)
                      : _buildCollectionsList(context),
            ),
            Center(
              child: Text(
                'Archived Content',
                style: TextStyle(fontFamily: 'Poppins-Regular'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.teal,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/no_bookmarks.jpg'),
          const Text(
            'No bookmarks yet',
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Add a bookmark to get started. Go search the web and save your favorite links.',
              style: TextStyle(fontFamily: 'Poppins-Light', fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          MyButton(
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            buttonText: 'Add a bookmark',
            onPressed: () {
              addBookmark(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BookmarkButtons(
              isSearchExpanded: isSearchExpanded,
              onSearchChanged: _searchBookmarks,
              onToggleSearch: toggleSearch,
              otherActions: [
                () => print("Filter button pressed"),
                () => print("Sort button pressed"),
                () => print("List view button pressed"),
                () => print("Checked view button pressed"),
              ],
            ),
          ),
          expandedHeight: 20, // Adjust height as needed
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              print("Has Searched: $hasSearched");
              print("Filtered Bookmarks Count: ${filteredBookmarks.length}");
              // Check if a search has been performed and there are no results
              if (hasSearched && filteredBookmarks.isEmpty) {
                return _buildEmptySearchResults(
                    context); // Return the search not found widget
              }
              // If there are bookmarks, return the bookmark card
              final bookmark =
                  filteredBookmarks[index]; // Use filteredBookmarks here
              return BookmarkCard(
                bookmark: bookmark,
                onBookmarkUpdated: _loadBookmarks,
                onBookmarkDeleted: _loadBookmarks,
                deleteCallback: (bookmarkId) async {
                  print(
                      'Attempting to delete bookmark with ID: $bookmarkId'); // Debug statement before deletion
                  await deleteBookmark(bookmarkId, context);
                  print('Bookmark with ID: $bookmarkId deleted');
                },
                onEdit: () async {
                  await navigateToEditBookmark(
                    context: context,
                    bookmarkId: bookmark.id,
                    collection: bookmark.id,
                    onEditSuccess: _loadBookmarks,
                  );
                },
              );
            },
            // Set childCount to the number of filtered bookmarks or 1 if no results and a search has been performed
            childCount: hasSearched && filteredBookmarks.isEmpty
                ? 1
                : filteredBookmarks.length,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionsList(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Add a SliverAppBar for the CollectionsButton
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: 60, // Adjust height as needed
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CollectionButtons(
              isSearchExpanded: isSearchExpanded,
              onSearchChanged: _searchBookmarks,
              onToggleSearch: toggleSearch,
              otherActions: [
                () {
                  // Add your action here
                  addCollection(context);
                },
                () => print("Checked view button pressed"),
              ],
            ),
          ),
        ),
        // Add the grid view as a SliverGrid
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0, // Adjust ratio to control item size
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final collection = collections[index];
                return CollectionCard(
                  collection: collection,
                  onOpen: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookmarkListScreen(
                          collectionId: collection.id,
                          collectionName: collection.name,
                          bookmarks: collection.bookmarks,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount:
                  collections.length, // Number of collections to display
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySearchResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/empty.jpg'),
          const Text(
            'Search query not found.',
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Try to search for something else',
              style: TextStyle(fontFamily: 'Poppins-Light', fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCollection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/file_searching.png'),
          const Text(
            'No collections',
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Collections are a folder that organizes your bookmarks',
              style: TextStyle(fontFamily: 'Poppins-Light', fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          MyButton(
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            buttonText: 'Create a collection',
            onPressed: () {
              addCollection(context);
            },
          ),
        ],
      ),
    );
  }
}
