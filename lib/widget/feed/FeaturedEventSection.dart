import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/event/create_event_screen1.dart';
import 'package:ocean_rescue/resources/event_firestor_methods.dart';
import '../../theme/colorTheme.dart';

class FeaturedEventSection extends StatefulWidget {
  const FeaturedEventSection({Key? key}) : super(key: key);

  @override
  _FeaturedEventSectionState createState() => _FeaturedEventSectionState();
}

class _FeaturedEventSectionState extends State<FeaturedEventSection> {
  // A notifier to hold the list of events
  ValueNotifier<List<Map<String, dynamic>>> eventsNotifier = ValueNotifier([]);
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  /// Fetch all events and update the notifier
  void _fetchAllEvents() async {
    try {
      final events = await EventFirestoreMethods.instance.getAllEvents();
      eventsNotifier.value = events;
      print("Events: $events");
    } catch (e) {
      print("Error loading events: $e");
      eventsNotifier.value = [];
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

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
          child: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: eventsNotifier,
            builder: (context, events, child) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (events.isEmpty) {
                return const Center(child: Text("No events available."));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length + 1, // +1 for "Create Event" card
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    // Create Event card
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the Create Event screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateEventScreen1(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        width: 150, // Set width for the card
                        height: 100, // Set height for the card
                        decoration: BoxDecoration(
                          color: ColorTheme.liteBlue2, // Highlight color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_box_outlined,
                              size: 40,
                              color: Colors.black54,
                            ),
                            SizedBox(height: 8), // Space between icon and text
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

                  // Regular event card
                  final event = events[index - 1]; // Adjust index for events
                  return Container(
                    margin: const EdgeInsets.only(left: 16),
                    width: 150, // Set width for the event card
                    height: 100, // Set height for the event card
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            event['image_url'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double
                                .infinity, // Ensure image fits the card size
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: SizedBox(
                            width: 130,
                            child: Text(
                              event['event_name'] ?? 'Untitled Event',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
