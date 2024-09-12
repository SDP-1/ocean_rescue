import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this package to handle image picking
import 'dart:io';

import '../../theme/colorTheme.dart';
import '../../widget/popup/ErrorPopup.dart';
import '../../widget/popup/SuccessPopup.dart';

void main() => runApp(MaterialApp(home: ReportDumpPage()));

class ReportDumpPage extends StatefulWidget {
  @override
  _ReportDumpPageState createState() => _ReportDumpPageState();
}

class _ReportDumpPageState extends State<ReportDumpPage> {
  File? _image; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Method to pick an image
  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo/logo_without_name.png', // replace with your logo asset
            height: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            // Create new Post
            Container(
              height: 80,
              decoration: BoxDecoration(
                // Horizontal gradient from left (08BDBD) to right (1877F2)
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF08BDBD), // Left-side color
                    Color(0xFF1877F2), // Right-side color
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Left-side image
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Image.asset(
                      'assets/post/createNewPost.png',
                      height: 70,
                      width: 70,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Report Dump',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Name TextField
            _buildLabeledTextField(
              label: 'Name',
              hintText: 'Enter your name',
            ),
            SizedBox(height: 16),

            // Description TextField
            _buildLabeledTextField(
              label: 'Description',
              hintText: 'Enter description',
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Urgency Level
            Text('Urgency Level'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                urgencyButton('Low', Colors.green),
                urgencyButton('Normal', Colors.blue),
                urgencyButton('High', Colors.orange),
                urgencyButton('Urgent', Colors.red),
              ],
            ),
            SizedBox(height: 16),

            // Event Location TextField
            _buildLabeledTextField(
              label: 'Event Location',
              hintText: 'Enter event location',
              suffixIcon: Icon(Icons.search),
            ),
            SizedBox(height: 16),

            // Map Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: ColorTheme.liteGreen1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text('Map Placeholder'),
              ),
            ),
            SizedBox(height: 16),

            // Image Preview
            Text(
              'Image Upload',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (_image != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'No Image Selected',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Centered upload image button
            Align(
              alignment: Alignment.center,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Image'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Report Dump Button
            GestureDetector(
              onTap: () {
                // Handle report dump logic here
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF08BDBD), // Left-side color
                      Color(0xFF1877F2), // Right-side color
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Post creation logic
                    showSuccessPopup(
                      context,
                      'Dump',
                      'Reported successfully.',
                    );
                    showErrorPopup(
                      context,
                      'You couldn\'t join',
                      'Please try again.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.transparent, // Remove any shadow
                  ),
                  child: const Text(
                    'Report Dump',
                    style: TextStyle(fontSize: 18, color: ColorTheme.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build a labeled TextField
  Widget _buildLabeledTextField({
    required String label,
    required String hintText,
    int? maxLines,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget urgencyButton(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  Widget imageThumbnail(String imagePath) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath), // Replace with actual image
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget uploadImageButton() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.upload),
    );
  }
}
