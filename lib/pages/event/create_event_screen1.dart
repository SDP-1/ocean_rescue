import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/common/CreateFormTopWidget.dart';
import 'dart:io';
import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';

import '../../widget/common/GradientButton.dart';

class CreateEventScreen1 extends StatefulWidget {
  @override
  _CreateEventScreen1State createState() => _CreateEventScreen1State();
}

class _CreateEventScreen1State extends State<CreateEventScreen1> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.white,
      appBar: AppBar(
        title: Image.asset(
          'assets/logo/logo_without_name.png',
          height: 40,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateFormTopWidget(
              title: 'Create New Event',
              imagePath: 'assets/post/createNewPost.png',
            ),
            // Top Instructional Info
            EventInfoAlert(
              alertText:
                  "Enter the event name, a small description of the event, and upload an image for the cover.",
            ),
            const SizedBox(height: 20),
            // Event Name
            const Text(
              'Event Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                hintText: 'Enter event name',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: ColorTheme.lightGreen1,
              ),
            ),
            const SizedBox(height: 16),
            // Event Description
            const Text(
              'Event Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _eventDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter event description',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: ColorTheme.lightGreen1,
              ),
            ),
            const SizedBox(height: 16),
            // Image Upload Section
            const Text(
              'Image',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(File(_image!.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _image == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Upload Image',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: OutlinedButton.icon(
                onPressed: _pickImage,
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
            const SizedBox(height: 20),
            // Size Section
            const Text(
              'Size',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSizeOption('2 - 5', Icons.people_outline),
                _buildSizeOption('5 - 20', Icons.groups_outlined),
                _buildSizeOption('20 +', Icons.people_alt_outlined),
              ],
            ),
            const SizedBox(height: 30),
            // Next Button
            GradientButton(
              text: 'Next',
              onTap: () {
                // Navigate or perform action
              },
              width: double.infinity, // Set width to take full width
              height: 50.0, // Optional: You can set a specific height if needed
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white, // Added background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
