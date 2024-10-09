import 'package:flutter/material.dart';

class CriticalDumpImage extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CriticalDumpImage({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Image widget
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          // Positioned title text with thin font
          Positioned(
            bottom: 8,
            left: 8,
            child: SizedBox(
              width: 130, // Limits the width of the text container
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white, // Keeps the text white for visibility
                  fontSize: 10,        // Reduced font size
                  fontWeight: FontWeight.w400, // Very thin font
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
