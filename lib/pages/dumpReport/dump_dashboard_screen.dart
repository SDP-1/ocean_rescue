import 'package:flutter/material.dart';
import 'package:ocean_rescue/models/reportdump.dart';
import 'package:ocean_rescue/resources/ReportDumpsFirestoreMethods.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/feed/TopAppBar%20.dart';
import 'package:ocean_rescue/widget/dumpReport/eventCard.dart';
import 'DumpReportHistory.dart';
import 'dump_description_edit.dart';
import 'dump_report_screen.dart';

class DumpsDashboard extends StatelessWidget {
  const DumpsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: TopAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Actions that will scroll with the content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dumps",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Let's Save Our Environment",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildActionIcon(
                        Icons.history,
                        "Report History",
                        ColorTheme.liteBlue1,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DumpReportHistory()),
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      _buildActionIcon(
                        Icons.report,
                        "Report Dump",
                        Colors.red,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportDumpPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Map Placeholder
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Nearby Dump",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              decoration: BoxDecoration(
                color: ColorTheme.liteBlue2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                // Optional: adds rounded corners to the image
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/dump/beach.png',
                  fit: BoxFit.cover, // Ensures the image covers the container
                  height: 150, // Set height to match the container
                  width: double
                      .infinity, // Make the image take the full width of the container
                ),
              ),
            ),

            // Critical Dumps Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Critical Dumps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
  height: 100,
  child: FutureBuilder<List<ReportDump>>(
    future: ReportDumpsFirestoreMethods().fetchReportedDumpReports(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Failed to load data."));
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        // Filter only the dumps with urgencyLevel = "Urgent"
        final criticalDumps = snapshot.data!
            .where((dump) => dump.urgencyLevel == "Urgent")
            .toList();

        // Check if there are any critical dumps
        if (criticalDumps.isNotEmpty) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: criticalDumps
                .map((dump) => GestureDetector(  // Use GestureDetector for tap detection
                      onTap: () {
                        // Navigate to DumpDetailsScreen when image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DumpDetailsScreen(
                              rdid: dump.rdid, // Pass the unique dump ID
                              title: dump.title, // Pass the title of the dump
                              description: dump.description, // Pass the description
                              imageUrl: dump.imageUrl,// Pass the image URL
                            ),
                          ),
                        );
                      },
                      child: CriticalDumpImage(dump.imageUrl), // Your existing widget for displaying images
                    ))
                .toList(),
          );
        } else {
          return const Center(child: Text("No critical dumps found."));
        }
      } else {
        return const Center(child: Text("No critical dumps found."));
      }
    },
  ),
),


            // All Dumps Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "All Dumps",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.filter_list),
                ],
              ),
            ),
            // Placeholder Event Cards (Replace these with fetched data if needed)
            EventCard(isCritical: true, imageUrl: 'assets/dump/dump1.jpeg'),
            EventCard(isCritical: false, imageUrl: 'assets/dump/dump1.jpeg'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ColorTheme.liteBlue1,
                    side:
                        const BorderSide(color: ColorTheme.liteBlue1, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Load more action
                  },
                  child: const Text("Load More"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onPressed,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.black54),
        ),
      ],
    );
  }
}

class CriticalDumpImage extends StatelessWidget {
  final String imageUrl;

  const CriticalDumpImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
