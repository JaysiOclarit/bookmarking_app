import 'package:flutter/material.dart';

class RectangleTile extends StatelessWidget {
  final String imagePath;
  final String buttonText; // Add a new parameter for the button text

  const RectangleTile({
    super.key,
    required this.imagePath,
    required this.buttonText, // Initialize the button text parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Use SizedBox to set a fixed height and width
      height: 56, // Set the height to match a typical TextField
      width: 370, // Set width to fill the available space
      child: ElevatedButton(
        onPressed: () {
          // add your logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
              0xFF13171a), // Set the button color (e.g., Google red)
          foregroundColor: Colors.white, // Set the text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          padding: EdgeInsets.zero, // Remove internal padding
        ),
        child: Row(
          // Use a Row to arrange the image and text horizontally
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 24, // Set a specific height for the image
              width: 24, // Set a specific width for the image
            ), // Display the image
            const SizedBox(width: 8), // Add some spacing between image and text
            Text(
              buttonText, // Display the text
              style: const TextStyle(
                fontSize: 16, // Customize text size
                fontFamily: 'Poppins-SemiBold',
                color: Colors
                    .white, // Customize text color to contrast with button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
