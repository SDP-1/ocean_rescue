import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  final String volunteerRange;
  final String eventDays;
  final String timeRange;
  final String location;
  final String date;

  const EventDetails({
    Key? key,
    required this.volunteerRange,
    required this.eventDays,
    required this.timeRange,
    required this.location,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // Margin around the card
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Inner padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use Row to place items side by side
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space between items
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem("🧑‍🤝‍🧑", volunteerRange),
                      const SizedBox(
                          height: 16), // Increased spacing between items
                      _buildDetailItem("📅", eventDays),
                      const SizedBox(
                          height: 16), // Increased spacing between items
                      _buildDetailItem("🕐", timeRange),
                    ],
                  ),
                ),
                const SizedBox(
                    width: 16), // Space between left and right columns
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem("📍", location),
                      const SizedBox(
                          height: 16), // Increased spacing between items
                      _buildDetailItem("🗓️", date),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
      children: [
        Text(
          "$icon ",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            maxLines: 2, // Limit to two lines to prevent overflow
            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
          ),
        ),
      ],
    );
  }
}
