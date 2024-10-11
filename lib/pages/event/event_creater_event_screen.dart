import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/event/EventDetailsCard.dart';
import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import 'package:ocean_rescue/resources/event_firestor_methods.dart';
import 'package:ocean_rescue/pages/qr/qr_genarator.dart';
import 'package:ocean_rescue/widget/navbar/TopAppBar%20.dart'; // Import the new QR generator screen

class EventCreaterDetailsScreen extends StatelessWidget {
  final String eventId; // Accept the eventId via the constructor

  const EventCreaterDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(selectedTabIndex: BottomNavBar.selectedTabIndex),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: EventFirestoreMethods.instance
            .getEventById(eventId), // Fetch event data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load event details.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Event not found.'));
          }

          // Event data retrieved successfully
          final eventData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                  16.0), // Uniform padding for the whole screen
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image (using image URL from event data)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      eventData['image_url'] ??
                          'https://via.placeholder.com/150', // Fallback if no image URL
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    eventData['description'] ??
                        'No description available.', // Load event description
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Event Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  EventDetailsCard(
                    volunteerRange:
                        "${eventData['group_size']} Volunteers", // Use data from the event
                    eventDays:
                        "Event Date: ${eventData['date']}", // Display event date
                    timeRange:
                        "${eventData['start_time']} - ${eventData['end_time']}", // Event time
                    location: eventData['location'] ?? 'Location not specified',
                    date: eventData['date'] ?? 'No date specified',
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Map",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Map Placeholder
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/event/map.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Event QR",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const EventInfoAlert(
                    alertText:
                        "Show the event QR code to the participants to join and complete the event.",
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Call the showQrCodePopup directly to show the QR code in a popup
                        showQrCodePopup(context,
                            eventData); // Make sure eventData is passed correctly
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.lightBlue1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.qr_code, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "View Event QR Code",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // child: ElevatedButton(
                    //   onPressed: () {
                    //     // Pass the eventData to the QR code popup
                    //     showQrCodePopup(context, eventData);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: ColorTheme.lightBlue1,
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 32, vertical: 16),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: const [
                    //       Icon(Icons.qr_code, color: Colors.white),
                    //       SizedBox(width: 8),
                    //       Text(
                    //         "View Event QR Code",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Participants - ${eventData['group_size']}", // Display number of participants
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // List of Participants (dummy data for now, assuming 25 participants)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 25, // Example number of participants
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text('Participant Name'),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            // Action to remove participant
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action to complete the event
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.lightBlue1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Click to Complete the Event",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
