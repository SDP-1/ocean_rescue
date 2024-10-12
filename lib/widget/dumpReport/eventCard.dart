import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

class EventCard extends StatelessWidget {
  final bool isCritical;
  final String imageUrl;
  final String title;
  final String description;
  final Color buttonColor;

  const EventCard({
    super.key,
    this.isCritical = false,
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
        color: ColorTheme.lightGreen1, // Changed background color to lightGreen1
        borderRadius: BorderRadius.circular(6), // Slightly smaller border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
            spreadRadius: 1, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image fills the left side
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              imageUrl,
              width: 120, // Adjust width to prevent overflow
              height: 100, // Adjust height to fit the card
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10), // Adjusted space between image and text column

          // Right side containing title, description, and buttons
          Expanded( // Ensures content adjusts within available space
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
                        // Empty onPressed for share action
                      },
                    ),

                    // Critical icon if the event is marked as critical
                    if (isCritical)
                      const Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 20, // Critical icon size
                      ),

                    const SizedBox(width: 10), // Space between icons and button

                    // Spacer to push the button to the right
                    const Spacer(),

                    // Fixed-size button
                    SizedBox(
                      width: 120, // Fixed width for the button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // Reduced button corner radius
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6), // Reduced vertical padding
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
                          overflow: TextOverflow.ellipsis, // Prevent button text overflow
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
