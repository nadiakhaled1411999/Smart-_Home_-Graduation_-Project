import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            child: const Divider(
              color: Colors.black, // Set the color of the line
              thickness: 1.0,
              indent: 30, // Set the thickness of the line
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("OR"),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            child: const Divider(
              color: Colors.black, // Set the color of the line
              thickness: 1.0,
              endIndent: 30, // Set the thickness of the line
            ),
          ),
        ),
      ],
    );
  }
}
