import 'package:final_project/core/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText; // Add a parameter for the button text
  final VoidCallback onPressed;
  final Color textColor; // Add a parameter for the text color
  final Color? backgroundColor;
  final Gradient? gradient; // Add a parameter for the button background color
  final double width; // Add a parameter for width
  final double height; // Add a parameter for height

  const MyButton({
    super.key,
    this.gradient,
    this.backgroundColor, // Initialize the background color parameter
    required this.textColor, // Initialize the text color parameter
    required this.buttonText,
    required this.onPressed, // Initialize the onPressed parameter
    this.width = 370, // Default width
    this.height = 56, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, // Set the height to match a typical TextField
      width: width, // Set width to fill the available space
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient, // Use the gradient if provided
          color: gradient == null
              ? backgroundColor
              : null, // Fallback to backgroundColor if no gradient
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: ElevatedButton(
          onPressed: onPressed, // Use the passed function for the button action
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, // Set the background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            padding: EdgeInsets.zero, // Remove internal padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText, // Display the text
                style: TextStyle(
                    fontSize: 16, // Customize text size
                    color: textColor,
                    fontFamily: 'Poppins-SemiBold' // Customize text color
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientElevatedButton extends StatelessWidget {
  final String buttonText; // Add a parameter for the button text
  final VoidCallback onPressed;
  final Color textColor; // Add a parameter for the text color
  final Color? backgroundColor;
  final Gradient? gradient; // Add a parameter for the button background color

  const GradientElevatedButton({
    super.key,
    this.gradient,
    this.backgroundColor, // Initialize the background color parameter
    required this.textColor, // Initialize the text color parameter
    required this.buttonText,
    required this.onPressed, // Initialize the onPressed parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // Set the height to match a typical TextField
      width: 370, // Set width to fill the available space
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient, // Use the gradient if provided
          color: gradient == null
              ? backgroundColor
              : null, // Fallback to backgroundColor if no gradient
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: ElevatedButton(
          onPressed: onPressed, // Use the passed function for the button action
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Set the background color
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            padding: EdgeInsets.zero, // Remove internal padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText, // Display the text
                style: TextStyle(
                    fontSize: 16, // Customize text size
                    color: textColor,
                    fontFamily: 'Poppins-SemiBold' // Customize text color
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookmarkButtons extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onToggleSearch;
  final List<VoidCallback> otherActions;
  final Color backgroundColor;
  final bool isSearchExpanded;

  const BookmarkButtons({
    super.key,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.otherActions,
    this.backgroundColor =
        const Color.fromARGB(255, 255, 255, 255), // Default background color
    required this.isSearchExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          if (isSearchExpanded)
            Expanded(
              child: AnimatedSearchBar(
                onChanged: onSearchChanged,
                onClose: onToggleSearch, // Pass the toggle callback
              ),
            )
          else ...[
            // Show other buttons only when search is not expanded
            _buildIconButton(
              icon: Icons.search,
              onPressed: onToggleSearch,
              backgroundColor: backgroundColor,
            ),
            const Spacer(),
            Row(
              children: List.generate(otherActions.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: index > 0 ? 14 : 0),
                  child: _buildIconButton(
                    icon: _getIconForIndexBookmark(index),
                    onPressed: otherActions[index],
                    backgroundColor: backgroundColor,
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return IconButtonWithIcon(
      icon: icon,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
    );
  }

  IconData _getIconForIndexBookmark(int index) {
    const icons = [
      Icons.tune, // Filter
      Icons.swap_vert, // Sort
      Icons.view_list, // List view
      Icons.check_box, // Checked view
    ];

    return icons[index % icons.length];
  }
}

class BookmarkButtonsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  BookmarkButtonsDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 4, // Optional: Add elevation for shadow
      child: Container(
        color: Colors.white, // Background color of the sticky header
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 100; // Height of the TabBarButtons widget

  @override
  double get minExtent => 100; // Same as maxExtent to keep the size fixed

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // No need to rebuild unless the widget changes
  }
}

class CollectionButtons extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onToggleSearch;
  final List<VoidCallback> otherActions;
  final Color backgroundColor;
  final bool isSearchExpanded;

  const CollectionButtons({
    super.key,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.otherActions,
    this.backgroundColor =
        const Color.fromARGB(255, 255, 255, 255), // Default background color
    required this.isSearchExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          if (isSearchExpanded)
            Expanded(
              child: AnimatedSearchBar(
                onChanged: onSearchChanged,
                onClose: onToggleSearch, // Pass the toggle callback
              ),
            )
          else ...[
            // Show other buttons only when search is not expanded
            _buildIconButton(
              icon: Icons.search,
              onPressed: onToggleSearch,
              backgroundColor: backgroundColor,
            ),
            const Spacer(),
            Row(
              children: List.generate(otherActions.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: index > 0 ? 14 : 0),
                  child: _buildIconButton(
                    icon: _getIconForIndexCollection(index),
                    onPressed: otherActions[index],
                    backgroundColor: backgroundColor,
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return IconButtonWithIcon(
      icon: icon,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
    );
  }

  IconData _getIconForIndexCollection(int index) {
    const icons = [
      Icons.plus_one, // Add collection
      Icons.check_box, // Checked view
    ];

    return icons[index % icons.length];
  }
}

class CollectionButtonsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  CollectionButtonsDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 4, // Optional: Add elevation for shadow
      child: Container(
        color: Colors.white, // Background color of the sticky header
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 100; // Height of the TabBarButtons widget

  @override
  double get minExtent => 100; // Same as maxExtent to keep the size fixed

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // No need to rebuild unless the widget changes
  }
}

class IconButtonWithIcon extends StatelessWidget {
  final IconData icon; // Icon data for the button
  final VoidCallback onPressed; // Callback for button press
  final Color? backgroundColor; // Background color

  const IconButtonWithIcon({
    super.key,
    this.backgroundColor,
    required this.icon, // Add icon parameter
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Set a smaller height for an icon button
      width: 40, // Set a smaller width for an icon button
      child: ElevatedButton(
        onPressed: onPressed, // Use the passed function for the button action
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Set the background color
          shape: CircleBorder(), // Make the button circular
          padding: EdgeInsets.zero, // Remove internal padding
        ),
        child: Icon(
          icon, // Display the icon
          color: Colors.black, // Set the icon color
          size: 24, // Customize icon size
        ),
      ),
    );
  }
}
