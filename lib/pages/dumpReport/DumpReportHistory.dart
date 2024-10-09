import 'package:flutter/material.dart';

// Define your color theme class as per the uploaded palette
import 'package:ocean_rescue/theme/colorTheme.dart';
import '../../widget/feed/TopAppBar .dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/reportdump.dart';
import '../../resources/ReportDumpsFirestoreMethods.dart';
import '../dumpReport/dump_description_edit.dart';

class DumpReportHistory extends StatefulWidget {
  @override
  _DumpReportHistoryState createState() => _DumpReportHistoryState();
}

class _DumpReportHistoryState extends State<DumpReportHistory> {
  List<ReportDump> _reportedDumps = [];
  List<ReportDump> _clearedDumps = [];
  bool _isLoading = true;
  bool _isSorted = false;
  @override
  void initState() {
    super.initState();
    _fetchDumpReports();
  }

 Future<void> _fetchDumpReports() async {
  // Fetch reported and cleared dumps from Firestore
  try {
    setState(() {
      _isLoading = true; // Start loading
    });

    // Fetch reported and cleared dumps
    List<ReportDump> reportedDumps = await ReportDumpsFirestoreMethods().fetchReportedDumpReports();
    List<ReportDump> clearedDumps = await ReportDumpsFirestoreMethods().fetchClearedDumpReports();

  // Debugging: print the fetched dumps
   print('Fetched reported dumps: ${_reportedDumps.length}');
    print('Fetched cleared dumps: ${_clearedDumps.length}');


    setState(() {
      _reportedDumps = reportedDumps; // Assign fetched reported dumps
      _clearedDumps = clearedDumps;   // Assign fetched cleared dumps
      _isLoading = false;              // Stop loading
    });

     // Optionally, print the updated state after setState
    print('Dumps (Reported): $_reportedDumps');
    print('Dumps (Cleared): $_clearedDumps');

    
  } catch (e) {
    // Handle the error (e.g., show an error message)
    print('Error fetching reports: $e');
    setState(() {
      _isLoading = false; // Stop loading
    });
  }
}

void _toggleSort() {
    setState(() {
      _isSorted = !_isSorted; // Toggle sorting state
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.white,
      appBar: TopAppBar(),
      body: Column(
        children: [
          // Add the back arrow and title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
               
                Text(
                  '\t\t\tDump Report History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorTheme.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/dump/dump1.jpeg', // Replace with your image path
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Reported Dumps'),
                              _buildDescriptionText('These are the dump sites reported by the community for clean-up.'),
                              _buildDumpList(isReported: true), // Update this method to use _reportedDumps
                              _buildPagination(), // Optionally, you can modify this to support pagination
                              _buildSectionTitle('Cleared Dumps'),
                              _buildDumpList(isReported: false), // Update this method to use _clearedDumps
                              _buildPagination(), // Optionally, you can modify this to support pagination
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Helper methods like _buildDumpList, _buildSectionTitle, and _buildDescriptionText should be defined below


  Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorTheme.darkBlue2,
          ),
        ),
        IconButton(
          icon: Icon(Icons.sort_by_alpha, color: ColorTheme.darkBlue2), // A-Z sorting icon
          onPressed: () {
           _toggleSort(); 
          },
        ),
      ],
    ),
  );
}


  Widget _buildDescriptionText(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 16,
          color: ColorTheme.black,
        ),
      ),
    );
  }

Widget _buildDumpList({required bool isReported}) {
  List<ReportDump> dumps = isReported ? _reportedDumps : _clearedDumps;

  // Sort dumps if _isSorted is true
  if (_isSorted) {
    dumps.sort((a, b) => a.title.compareTo(b.title)); // Sort alphabetically
  }

  if (dumps.isEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text('No ${isReported ? "reported" : "cleared"} dumps available.'),
    );
  }

  return ListView.builder(
    physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
    shrinkWrap: true, // Allow ListView to take the height of its children
    itemCount: dumps.length,
    itemBuilder: (context, index) {
      final ReportDump report = dumps[index]; // Explicitly declare the type as ReportDump
      return GestureDetector(
        onTap: () {
          // Navigate to DumpDetailsScreen when the card is tapped, passing rdid, title, and description
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                print('Navigating to details:');
                print('Dump ID: ${report.rdid}');
                print('Title: ${report.title}');
                print('Description: ${report.description}');
                print('Image URL: ${report.imageUrl}');
                
                return DumpDetailsScreen(
                  rdid: report.rdid, // Pass the unique rdid
                  title: report.title, // Pass the title
                  description: report.description, // Pass the description
                  imageUrl: report.imageUrl,  
                  uid: report.uid, 
                );
              },
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Add padding for better spacing
            child: Row(
              children: [
                // Left Image Container
                Container(
                  width: 80, // Set image width
                  height: 60, // Set image height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(report.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12), // Spacing between image and text
                
                // Description Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4), // Spacing between title and description
                      Text(
                        report.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600], // Optional: Set a lighter color for the description
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Delete Icon Button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Add your delete logic here
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



Widget _buildPagination() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left arrow before the first page number, positioned at the far left
          Container(
            width: 25, // Reduced circle size
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.darkBlue2, // Blue background
            ),
            child: IconButton(
              iconSize: 8, // Smaller icon size
              icon: FaIcon(FontAwesomeIcons.chevronLeft, color: ColorTheme.white),
              onPressed: () {
                // Logic for the previous page
              },
            ),
          ),
          // Pagination numbers
          Row(
            children: List.generate(12, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircleAvatar(
                  radius: 12, // Reduced radius for a smaller circle
                  backgroundColor: index == 0 // Change to check for the first index
                      ? ColorTheme.liteBlue1
                      : ColorTheme.litegray,
                  child: Text(
                    '${index + 1}', // This will correctly show page numbers starting from 1
                    style: TextStyle(
                      fontSize: 12, // Adjust font size for smaller text
                      color: index == 0 ? ColorTheme.white : ColorTheme.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          // Right arrow after the last page number, positioned at the far right
          Container(
            width: 25, // Reduced circle size
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.darkBlue2, // Blue background
            ),
            child: IconButton(
              iconSize: 8, // Smaller icon size
              icon: FaIcon(FontAwesomeIcons.chevronRight, color: ColorTheme.white),
              onPressed: () {
                // Logic for the next page
              },
            ),
          ),
        ],
      ),
    ),
  );
}



}
