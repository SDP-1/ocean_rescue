import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

class EventCard extends StatelessWidget {
  final bool isCritical;
  final String imageUrl;
  final Color backgroundColor;
  final Color buttonColor;

  const EventCard({super.key, 
    this.isCritical = false,
    this.backgroundColor = const Color(0xFFE3F2FD),
    this.buttonColor = const Color(0xFF4CAF50),
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced margin
      padding: const EdgeInsets.all(8), // Reduced padding
      decoration: BoxDecoration(
        color: isCritical ? ColorTheme.lightRed2 : backgroundColor,
        borderRadius:
            BorderRadius.circular(6), // Slightly smaller border radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with reduced size
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                  imageUrl,
                  width: 110, // Reduced image width
                  height: 65, // Reduced image height
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8), // Reduced space between image and text
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Galle Face Dump",
                      style: TextStyle(
                        fontSize: 13, // Reduced title size
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2), // Smaller gap
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                      style:
                          TextStyle(fontSize: 11), // Reduced description size
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // Reduced gap before buttons

          // Icons and button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Share and Warning icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      size: 20, // Smaller icon size
                    ),
                    onPressed: () {
                      // Share action
                    },
                  ),
                  if (isCritical)
                    const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 20, // Smaller warning icon
                    ),
                ],
              ),
              // Let's Clean Up button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCritical ? ColorTheme.lightRed : buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16), // Reduced button corner radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6), // Reduced padding
                ),
                onPressed: () {
                  // Clean Up action
                },
                child: const Text(
                  "Let's Clean Up",
                  style: TextStyle(
                      fontSize: 11,
                      color: ColorTheme.black), // Smaller button text
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
