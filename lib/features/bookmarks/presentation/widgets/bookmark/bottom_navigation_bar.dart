import 'package:final_project/features/bookmarks/presentation/pages/add_bookmark_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/profile_page.dart';
import 'package:final_project/features/bookmarks/presentation/pages/tab_bar_page.dart'; // Import the Tab Bar page
import 'package:final_project/features/bookmarks/presentation/pages/tab_page.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  _BottomNavigationBarPageState createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TabBarPage(), // Bookmarks with Tab Bar
    AddBookmarkPage(), // Add Page
    const ProfilePage(), // Account Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontFamily: 'Poppins-Medium'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins-Medium'),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Theme.of(context).colorScheme.inverseSurface,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
