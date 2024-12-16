import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final controller;

  const MyTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.controller, // Accept hint text in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                labelText, // You can replace this with labelText if needed
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 20,
                    fontFamily: 'Poppins-SemiBold'),
              ),
            ],
          ),
          const SizedBox(height: 8), // Space between label and TextField
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                    color: Colors.grey, fontFamily: 'Poppins-Light')),
          ),
        ],
      ),
    );
  }
}

// New custom text field design
class MyCustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyCustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontSize: 18,
                fontFamily: 'Poppins-SemiBold'),
          ),
          const SizedBox(height: 8), // Space between label and TextField
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, // Custom background color
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(20), // Different border radius
                // Remove border line
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                  color: Colors.blueGrey, fontFamily: 'Poppins-Light'),
            ),
          ),
        ],
      ),
    );
  }
}
