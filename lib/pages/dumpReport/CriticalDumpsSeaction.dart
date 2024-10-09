import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/dumpReport/dump_description_edit.dart';
import '../../models/reportdump.dart';
import '../../resources/ReportDumpsFirestoreMethods.dart';
import 'CriticalDumpImage.dart';


class CriticalDumpSection extends StatelessWidget {
  const CriticalDumpSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        .map((dump) => GestureDetector(
                              onTap: () {
                                // Navigate to DumpDetailsScreen when image is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DumpDetailsScreen(
                                      rdid: dump.rdid, // Pass the unique dump ID
                                      title: dump.title, // Pass the title of the dump
                                      description: dump.description, // Pass the description
                                      imageUrl: dump.imageUrl, // Pass the image URL
                                    ),
                                  ),
                                );
                              },
                              child: CriticalDumpImage(
                                imageUrl: dump.imageUrl,
                                title: dump.title,
                              ),
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
      ],
    );
  }
}
