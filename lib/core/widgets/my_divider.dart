import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "OR",
              style: TextStyle(
                fontFamily: 'Poppins-Black',
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
          const Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.grey,
          ))
        ],
      ),
    );
  }
}
