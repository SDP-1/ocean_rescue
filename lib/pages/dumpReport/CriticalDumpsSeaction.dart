import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/dumpReport/dump_description_edit.dart';
import '../../models/reportdump.dart';
import '../../resources/ReportDumpsFirestoreMethods.dart';
import 'CriticalDumpImage.dart';

class CriticalDumpSection extends StatefulWidget {
  const CriticalDumpSection({super.key});

  @override
  _CriticalDumpSectionState createState() => _CriticalDumpSectionState();
}

class _CriticalDumpSectionState extends State<CriticalDumpSection> {
  ValueNotifier<List<ReportDump>> criticalDumpsNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() async {
    final dumps = await ReportDumpsFirestoreMethods().fetchReportedDumpReports();
    criticalDumpsNotifier.value = dumps.where((dump) => dump.urgencyLevel == "Urgent").toList();
  }

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
          child: ValueListenableBuilder<List<ReportDump>>(
            valueListenable: criticalDumpsNotifier,
            builder: (context, criticalDumps, child) {
              if (criticalDumps.isEmpty) {
                return const Center(child: Text("No critical dumps found."));
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: criticalDumps.map((dump) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to DumpDetailsScreen when image is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DumpDetailsScreen(
                            rdid: dump.rdid, // Pass the unique dump ID
                            title: dump.title, // Pass the title of the dump
                            description: dump.description, // Pass the description
                            imageUrl: dump.imageUrl,
                            uid:dump.uid, // Pass the image URL
                          ),
                        ),
                      ).then((_) {
                        // This runs after returning from the details screen
                        _fetchInitialData(); // Refresh the list after going back
                      });
                    },
                    child: CriticalDumpImage(
                      imageUrl: dump.imageUrl,
                      title: dump.title,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
