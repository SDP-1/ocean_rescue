import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/event/EventDetailsCard.dart';
import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import 'package:ocean_rescue/widget/navbar/TopAppBar%20.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(selectedTabIndex: BottomNavBar.selectedTabIndex),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top with padding
            Padding(
              padding:
                  const EdgeInsets.all(5.0), // Adjust the padding as needed
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/event/event01.png', // Ensure this path is correct
                  fit: BoxFit.cover,
                  height: 200, // Adjust height according to your needs
                  width: double.infinity,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Event Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const EventDetails(
              volunteerRange:
                  "25 - 50 Volunteers", // Passing the volunteer range
              eventDays: "Every Thursday", // Passing the event days
              timeRange: "1:00 PM - 4:00 PM", // Passing the time range
              location: "Gale Face Beach, Colombo", // Passing the location
              date: "2024/09/06", // Passing the date
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Map",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Map Placeholder
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200, // Placeholder color
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/event/map.png', // Ensure this path is correct
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Join Event",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const EventInfoAlert(
                alertText:
                    "Scan the QR Code to join the event. Once you are done helping out, please scan the QR Code again to earn XP and unlock new achievements.", // Pass the text here
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action for scanning QR Code
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.lightBlue1,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Size the button according to its content
                  children: [
                    const Icon(
                      Icons
                          .qr_code, // Change this to your custom icon if needed
                      color: Colors.white, // Set icon color to white
                    ),
                    const SizedBox(width: 8), // Spacing between icon and line
                    Container(
                      width: 1, // Width of the vertical line
                      height: 24, // Height of the vertical line
                      color: Colors.white, // Color of the line
                    ),
                    const SizedBox(width: 8), // Spacing between line and text
                    const Text(
                      "Scan QR Code to Join the Event",
                      style: TextStyle(
                          color: Colors.white), // Ensure text is white as well
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
