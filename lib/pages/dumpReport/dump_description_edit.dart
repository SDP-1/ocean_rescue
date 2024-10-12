import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocean_rescue/widget/popup/SuccessPopup.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'dart:io'; // For file handling
import '../../resources/ReportDumpsFirestoreMethods.dart'; // Import your Firestore methods file
import '../../resources/auth_methods.dart';
import '../../resources/storage_methods.dart'; // Import storage methods

class DumpDetailsScreen extends StatefulWidget {
  final String rdid; // Unique dump ID
  final String title; // Dump title
  final String description; // Dump description
  final String imageUrl; // Image URL
  final String uid; // User ID associated with the dump

  DumpDetailsScreen({
    required this.rdid,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.uid, // Accept user ID
  });

  @override
  _DumpDetailsScreenState createState() => _DumpDetailsScreenState();
}

class _DumpDetailsScreenState extends State<DumpDetailsScreen> {
  final ReportDumpsFirestoreMethods _firestoreMethods = ReportDumpsFirestoreMethods();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late String rdid;
  late String title;
  late String description;
  late String imageUrl;

  File? _imageFile; // To store the selected image file
  bool isEditing = false; // To track whether we're in edit mode or not
  String? currentUserUid; // To hold the current user ID

  @override
  void initState() {
    super.initState();

    // Get the current user's ID
    AuthMethods authMethods = AuthMethods();
    currentUserUid = authMethods.getCurrentUserId();

    rdid = widget.rdid;
    title = widget.title;
    description = widget.description;
    imageUrl = widget.imageUrl;

    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Function to select an image from the gallery
  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToStorage(String rdid, File imageFile) async {
    // Replace this with your image upload logic
    String imageUrl = await _firestoreMethods.uploadImageToStorage(rdid, imageFile);
    return imageUrl; // Return the new image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: _imageFile == null
                    ? Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            height: 200,
                            width: double.infinity,
                            child: Center(
                              child: Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          );
                        },
                      )
                    : Image.file(
                        _imageFile!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 16),
              if (isEditing) // Only show the button to select a new image in edit mode
                TextButton.icon(
                  icon: Icon(Icons.image,color: Colors.lightBlue),
                  label: Text("Select New Image", style: TextStyle(color: Colors.lightBlue)),
                  onPressed: _selectImage,
                ),
              SizedBox(height: 16),
              _buildEditableSection(),
              SizedBox(height: 16),
              if (isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _updateDetails,
                      child: Text('Save'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          titleController.text = widget.title;
                          descriptionController.text = widget.description;
                          title = widget.title;
                          description = widget.description;
                          imageUrl = widget.imageUrl;
                          isEditing = false; // Exit edit mode
                        });
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        isEditing
            ? TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Edit Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    title = value; // Update title in real-time
                  });
                },
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.indigo.shade300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (currentUserUid == widget.uid)
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.indigo),
                      onPressed: () {
                        setState(() {
                          isEditing = true; // Enter edit mode
                        });
                      },
                    ),
                ],
              ),
        SizedBox(height: 16),
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        isEditing
            ? TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Edit Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    description = value; // Update description in real-time
                  });
                },
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.indigo.shade300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Future<void> _updateDetails() async {
    if (rdid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document ID is empty!')),
      );
      return; // Exit if ID is empty
    }

    String? newImageUrl = widget.imageUrl;
    if (_imageFile != null) {
      // Upload the selected image and get the URL
      newImageUrl = await uploadImageToStorage(rdid, _imageFile!);
    }

    // Save the updated values to Firestore
    await _firestoreMethods.updateDumpDetails(
      rdid,
      title,
      description,
      newImageUrl, // Save the new image URL
    );

    showSuccessPopup(context, title, 'Dump details updated successfully');

    setState(() {
      isEditing = false;
    });

    Navigator.pop(context, {
      'title': title,
      'description': description,
      'imageUrl': newImageUrl, // Return the new image URL to previous screen
    });
  }
}
