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
  late Future<List<ReportDump>> futureDumps;

  @override
  void initState() {
    super.initState();
    // Fetch the dump reports when the widget is initialized
    futureDumps = ReportDumpsFirestoreMethods().fetchAllDumpReports(); // Get instance of ReportDumpsFirestoreMethods
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReportDump>>(
      future: futureDumps,
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
          children: dumpReports.map((dump) {
            return EventCard(
              //isCritical: dump.isCritical, // Pass critical status
              imageUrl: dump.imageUrl,
              title: dump.title,
              description: dump.description,
            );
          }).toList(),
        );
      },
    );
  }
}
