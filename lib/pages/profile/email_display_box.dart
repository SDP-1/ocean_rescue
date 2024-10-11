import 'package:flutter/material.dart';

class EmailDisplayBox extends StatelessWidget {
  final String email;

  const EmailDisplayBox({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get the screen width

    return Container(
      width: screenWidth, // Set the width to the screen width
      padding: const EdgeInsets.all(16.0), // Padding around the text
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color of the box
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        border: Border.all(color: Colors.grey), // Optional border
      ),
      child: Text(
        "Email: $email", // Display the email directly
        style: const TextStyle(fontSize: 14, color: Colors.black), // Style as needed
      ),
    );
  }
}

