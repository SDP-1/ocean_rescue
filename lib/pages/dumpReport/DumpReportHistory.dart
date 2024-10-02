import 'package:flutter/material.dart';

// Define your color theme class as per the uploaded palette
import 'package:ocean_rescue/theme/colorTheme.dart';
import '../../widget/feed/TopAppBar .dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DumpReportHistory(),
    );
  }
}

class DumpReportHistory extends StatelessWidget {
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
                // IconButton(
                //   icon: Icon(Icons.arrow_back, color: ColorTheme.black),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
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
            child: SingleChildScrollView(
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
                        _buildDescriptionText(
                            'These are the dump sites reported by the community for clean-up.'),
                        _buildDumpList(isReported: true),
                        _buildPagination(),
                        _buildSectionTitle('Cleared Dumps'),
                        _buildDumpList(isReported: false),
                        _buildPagination(),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ColorTheme.darkBlue2,
        ),
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
  // Sample list data
  final List<String> dumpNames = [
    'Galle Face Dump',
    'Collupity Dump',
    'Ahungalla Dump',
  ];

  return Column(
    children: dumpNames.map((dumpName) {
      return Card(
        color: ColorTheme.liteGreen1,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Image.asset(
            'assets/dump/dump1.jpeg', // Replace with your image path
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(
            dumpName,
            style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorTheme.black,
            ),
          ),
          // Always show the delete icon regardless of isReported
          trailing: IconButton(
            icon: Icon(Icons.delete, color: ColorTheme.red),
            onPressed: () {
              // Add delete logic here
            },
          ),
        ),
      );
    }).toList(),
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
            width: 36, // Reduced circle size
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.darkBlue2, // Blue background
            ),
            child: IconButton(
              iconSize: 16, // Smaller icon size
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
                  backgroundColor: index == 1
                      ? ColorTheme.liteBlue1
                      : ColorTheme.litegray,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12, // Adjust font size for smaller text
                      color: index == 1 ? ColorTheme.white : ColorTheme.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          // Right arrow after the last page number, positioned at the far right
          Container(
            width: 36, // Reduced circle size
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorTheme.darkBlue2, // Blue background
            ),
            child: IconButton(
              iconSize: 16, // Smaller icon size
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
