import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

class EventCard extends StatelessWidget {
  final bool isCritical;
  final String imageUrl;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color buttonColor;

  const EventCard({
    super.key,
    this.isCritical = false,
    this.backgroundColor = const Color(0xFFE3F2FD),
    this.buttonColor = const Color(0xFF4CAF50),
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced margin
      padding: const EdgeInsets.all(8), // Reduced padding
      decoration: BoxDecoration(
        color: isCritical ? ColorTheme.lightRed2 : backgroundColor,
        borderRadius: BorderRadius.circular(6), // Slightly smaller border radius
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image fills the left side
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              imageUrl,
              width: 160, // Adjust width to fit the card
              height: 100, // Adjust height to fit the card
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 30), // Space between image and text column

          // Right side containing title, description, and buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13, // Reduced title size
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2), // Smaller gap
                // Description
                Text(
                  description,
                  style: const TextStyle(fontSize: 11), // Reduced description size
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 6), // Gap before the button row

                // Icons and button row
                Row(
                  children: [
                    // Share icon
                    IconButton(
                      icon: const Icon(
                        Icons.share,
                        size: 20, // Smaller icon size
                      ),
                      onPressed: () {
                        // Share action
                      },
                    ),
                    // Let's Clean Up button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCritical ? ColorTheme.lightRed : buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // Reduced button corner radius
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
                      ),
                      onPressed: () {
                        // Clean Up action
                      },
                      child: const Text(
                        "Let's Clean Up",
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorTheme.black, // Smaller button text
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
