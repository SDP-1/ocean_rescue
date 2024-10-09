import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocean_rescue/widget/popup/SuccessPopup.dart';
import '../../resources/ReportDumpsFirestoreMethods.dart'; // Import your Firestore methods file
import '../../resources/auth_methods.dart';

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
  final ReportDumpsFirestoreMethods _firestoreMethods =
      ReportDumpsFirestoreMethods();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late String rdid;
  late String title;
  late String description;

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

    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
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
                child: Image.network(
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
                ),
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
                  // Conditionally render the IconButton based on user ID
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

    // Save the updated values to Firestore
    await _firestoreMethods.updateDumpDetails(
      rdid,
      title,
      description,
    );

    showSuccessPopup(context, title, 'Dump details updated successfully');

    setState(() {
      isEditing = false;
    });

    Navigator.pop(context, {
      'title': title,
      'description': description,
    });
  }
}
