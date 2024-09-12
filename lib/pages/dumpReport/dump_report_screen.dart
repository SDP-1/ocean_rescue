import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/feed/TopAppBar%20.dart';

import '../../widget/dumpReport/eventCard.dart';
import 'dump_dashboard_screen.dart';

class DumpsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
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
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns children to the left
                    children: [
                      Text(
                        "Dumps",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Lorem Ipsum Event ipsum lorem",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Set color to gray
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
                          // Add report history action
                        },
                      ),
                      SizedBox(width: 5), // Space between icons
                      _buildActionIcon(
                        Icons.report,
                        "Report Dump",
                        Colors.red,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReportDumpPage()), // Replace `ReportDumpPage` with your target page widget
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Rest of the content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Nearby Dump",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              decoration: BoxDecoration(
                color: ColorTheme.liteBlue2, // Background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Center(child: Text('Map Placeholder')),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Critical Dumps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CriticalDumpImage('assets/dump/dump1.jpeg'),
                  CriticalDumpImage('assets/dump/dump2.jpeg'),
                  CriticalDumpImage('assets/dump/dump3.jpg'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
            // For the critical event card:
            EventCard(
              isCritical: true,
              imageUrl: 'assets/dump/dump1.jpeg',
            ),

            EventCard(
              isCritical: false,
              imageUrl: 'assets/dump/dump1.jpeg',
            ),

            EventCard(
              isCritical: false,
              imageUrl: 'assets/dump/dump1.jpeg',
            ),

            EventCard(
              isCritical: false,
              imageUrl: 'assets/dump/dump1.jpeg',
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // Background color of the button
                    foregroundColor:
                        ColorTheme.liteBlue1, // Text color of the button
                    side: BorderSide(
                        color: ColorTheme.liteBlue1,
                        width: 2), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Load more action
                  },
                  child: Text("Load More"),
                ),
              ),
            )
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
          margin: EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24), // Small icon size
            onPressed: onPressed,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 9, color: Colors.black54),
        ),
      ],
    );
  }
}

class CriticalDumpImage extends StatelessWidget {
  final String imagePath;

  CriticalDumpImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
