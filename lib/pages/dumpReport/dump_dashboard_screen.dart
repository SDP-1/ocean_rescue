import 'package:flutter/material.dart';
import 'package:ocean_rescue/models/reportdump.dart';
import 'package:ocean_rescue/resources/ReportDumpsFirestoreMethods.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/feed/TopAppBar%20.dart';
import 'package:ocean_rescue/widget/dumpReport/eventCard.dart';
import 'AllDumpsSection.dart';
import 'DumpReportHistory.dart';
import 'dump_description_edit.dart';
import 'dump_report_screen.dart';
import 'CriticalDumpsSeaction.dart';

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
                  width: double.infinity, // Full width of the container
                ),
              ),
            ),

            // Critical Dumps Section
            const CriticalDumpSection(),  // Using the extracted CriticalDumpSection

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
            const AllDumpsSection(), 
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