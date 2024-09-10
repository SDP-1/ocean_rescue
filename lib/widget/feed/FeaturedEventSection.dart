import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/event/create_event_screen.dart';
import '../../theme/colorTheme.dart';

class FeaturedEventSection extends StatelessWidget {
  const FeaturedEventSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Featured Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // Horizontal scroll for events
        SizedBox(
          height: 120, // Height of the event section
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mockEventData.length, // Mock event data length
            itemBuilder: (ctx, index) {
              final event = mockEventData[index];

              if (event['title'] == 'Create Event') {
                return GestureDetector(
                  onTap: () {
                    // Navigate to a new screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEvent(), // Replace with your new screen widget
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    width: 100, // Width for each event card
                    decoration: BoxDecoration(
                      color: ColorTheme.liteBlue2, // Highlight color for the "Create Event" card
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_box_outlined,
                          size: 40,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 8), // Space between icon and text
                        Text(
                          'Create Event',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.only(left: 16),
                width: 100, // Width for each event card
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.asset(
                          event['imageUrl']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        event['title'] ?? 'Untitled Event',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Mock event data
final List<Map<String, String>> mockEventData = [
  {
    'title': 'Create Event',
    'imageUrl': 'assets/event/event01.png',
  },
  {
    'title': 'Beach Cleanup',
    'imageUrl': 'assets/event/event01.png',
  },
  {
    'title': 'Fundraising',
    'imageUrl': 'assets/event/event01.png',
  },
  {
    'title': 'Fundraising',
    'imageUrl': 'assets/event/event01.png',
  },
  {
    'title': 'Fundraising',
    'imageUrl': 'assets/event/event01.png',
  },
  {
    'title': 'Fundraising',
    'imageUrl': 'assets/event/event01.png',
  },
  // Add more events as needed
];
