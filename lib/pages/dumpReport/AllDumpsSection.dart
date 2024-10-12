import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import '../../resources/ReportDumpsFirestoreMethods.dart';
import 'package:ocean_rescue/widget/dumpReport/eventCard.dart';
import '../../models/reportdump.dart';

class AllDumpsSection extends StatefulWidget {
  const AllDumpsSection({super.key});

  @override
  _AllDumpsSectionState createState() => _AllDumpsSectionState();
}

class _AllDumpsSectionState extends State<AllDumpsSection> {
  int _visibleCardCount = 5; // Start by showing 5 cards

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReportDump>>(
      // Stream for real-time updates
      stream: ReportDumpsFirestoreMethods().streamAllDumpReports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if fetching data fails
          return const Center(child: Text('Failed to load dump reports'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Show message if no data is available
          return const Center(child: Text('No dump reports available'));
        }

        // If data is available, display it in the EventCard widgets
        final dumpReports = snapshot.data!;
        
        return Column(
          children: [
            // Display the limited number of cards based on _visibleCardCount
            ...dumpReports.take(_visibleCardCount).map((dump) {
              return EventCard(
                imageUrl: dump.imageUrl,
                title: dump.title,
                description: dump.description,
                isCritical: dump.urgencyLevel == "Urgent", // Set isCritical based on urgency level
              );
            }).toList(),
            
            // Load More button
            if (_visibleCardCount < dumpReports.length) // Show button if there are more cards
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[300], // Light grey background
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {
                  setState(() {
                    _visibleCardCount += 5; // Increase the number of visible cards by 5
                  });
                },
                child: const Text(
                  'Load More',
                  style: TextStyle(color: Colors.black), // Text color
                ),
              ),
          ],
        );
      },
    );
  }
}
