import 'package:flutter/material.dart';

class DumpDetailsScreen extends StatelessWidget {
  final String rdid;         // Unique dump ID
  final String title;        // Dump title
  final String description;  // Dump description
  final String imageUrl;     // Image URL

  // Constructor that accepts all required parameters
  DumpDetailsScreen({
    required this.rdid,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,  // Use the title parameter for the AppBar title
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated Image Section: Use imageUrl to load the image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,  // Use the passed imageUrl parameter
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Description section
            Row(
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8), // Adjust spacing between text and icon
                Icon(Icons.edit, color: Colors.indigo),
              ],
            ),
            SizedBox(height: 8),

            // Display the description passed as a parameter
            Text(
              description,
              style: TextStyle(
                color: Colors.indigo.shade300,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
