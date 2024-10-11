import 'package:flutter/material.dart';
import 'package:ocean_rescue/resources/event_firestor_methods.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

class AllEventsSection extends StatefulWidget {
  const AllEventsSection({super.key});

  @override
  _AllEventsSectionState createState() => _AllEventsSectionState();
}

class _AllEventsSectionState extends State<AllEventsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // All Events Header
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                "All Events",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.filter_list),
            ],
          ),
        ),

        // Fetch and Display Event Cards
        FutureBuilder<List<Map<String, dynamic>>>(
          future: EventFirestoreMethods.instance.getAllEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load events.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No events available.'));
            }

            // If data is available, display it in event cards
            final events = snapshot.data!;
            return Column(
              children: events.map((event) {
                return _buildEventCard(
                  imageUrl:
                      event['image_url'] ?? 'https://via.placeholder.com/150',
                  title: event['event_name'] ?? 'Untitled Event',
                  date: event['date'] ?? 'Date not available',
                  time:
                      "${event['start_time'] ?? 'Start time'} - ${event['end_time'] ?? 'End time'}",
                  location: event['location'] ?? 'Location not specified',
                  volunteers: event['group_size'] ?? 'Unknown group size',
                  status: event['status'] ?? 'Status unknown',
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // Helper method to build event cards with real data
  Widget _buildEventCard({
    required String imageUrl,
    required String title,
    required String date,
    required String time,
    required String location,
    required String volunteers,
    required String status,
  }) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Scheduled':
          return Colors.orange;
        case 'In Progress':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        height: 130, // Slightly increased height for better layout
        child: Card(
          color: ColorTheme.lightGreen1, // Custom card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              // Stack used to position the status at the bottom-right
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns to the top
                  children: [
                    // Event image
                    Container(
                      width: 130,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Space between image and text

                    // Expanded column for event details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event title
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow:
                                TextOverflow.ellipsis, // Ellipsis for long text
                            maxLines: 1, // Single line for the title
                          ),
                          const SizedBox(height: 8),

                          // Date and Time
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$date | $time',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  overflow: TextOverflow
                                      .ellipsis, // Ellipsis for long text
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Volunteers count
                          Row(
                            children: [
                              const Icon(Icons.group,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$volunteers Volunteers',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  overflow: TextOverflow
                                      .ellipsis, // Ellipsis for long text
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Location
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  overflow: TextOverflow
                                      .ellipsis, // Ellipsis for long text
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Status indicator placed at the bottom-right
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 8, // Smaller font size for status
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
