import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/event/event_details_screen.dart';
import 'package:ocean_rescue/resources/event_firestor_methods.dart';

class FeaturedEventsSection extends StatefulWidget {
  const FeaturedEventsSection({Key? key}) : super(key: key);

  @override
  _FeaturedEventsSectionState createState() => _FeaturedEventsSectionState();
}

class _FeaturedEventsSectionState extends State<FeaturedEventsSection> {
  // A notifier to hold the list of events
  ValueNotifier<List<Map<String, dynamic>>> eventsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  /// Fetch all events and update the notifier
  void _fetchAllEvents() async {
    try {
      // Fetch all events from Firestore
      final events = await EventFirestoreMethods.instance.getAllEvents();
      eventsNotifier.value = events;

      print("Events : $events");
    } catch (e) {
      print("Error loading events: $e");
      eventsNotifier.value = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Featured Event",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 100,
          child: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: eventsNotifier,
            builder: (context, events, child) {
              if (events.isEmpty) {
                return const Center(child: Text("No events available."));
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: events.map((event) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Event Details Screen when tapped
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EventDetailsScreen(
                      //       eventId: event['id'], // Pass event ID
                      //       eventName: event['event_name'],
                      //       description: event['description'],
                      //       imageUrl: event['image_url'],
                      //     ),
                      //   ),
                      // ).then((_) {
                      //   _fetchAllEvents(); // Refresh the list after returning
                      // });
                    },
                    child: _buildEventCard(event),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Helper method to build event cards
  Widget _buildEventCard(Map<String, dynamic> event) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(event['image_url']),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: AlignmentDirectional.bottomStart,
            // decoration: BoxDecoration(
            // color: Colors.black.withOpacity(0.5),
            // borderRadius:
            //     const BorderRadius.vertical(bottom: Radius.circular(10)),
            // ),
            child: Text(
              event['event_name'],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
