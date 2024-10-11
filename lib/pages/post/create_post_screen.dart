import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/common/CreateFormTopWidget.dart';
import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';
import 'package:ocean_rescue/widget/popup/ErrorPopup.dart';
import 'package:ocean_rescue/widget/popup/SuccessPopup.dart';
import 'package:ocean_rescue/resources/post_firestore_methods.dart';
import 'package:ocean_rescue/pages/feed/feed_screen.dart';

import '../../widget/common/GradientButton.dart'; // Import your Feed screen

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _image;
  final PostFireStoreMethods _fireStoreMethods = PostFireStoreMethods();

  bool isLoading = false; // Loading state to show loading indicator

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = image;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _image = image;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createPost() async {
    setState(() {
      isLoading = true; // Set loading to true when post creation starts
    });

    String uid = FirebaseAuth.instance.currentUser!.uid;
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (_image != null) {
      String result = await _fireStoreMethods.createPost(
        title,
        description,
        File(_image!.path).readAsBytesSync(),
      );

      if (result == "success") {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const FeedScreen()),
            (route) => false,
          );
          showSuccessPopup(context, 'Create New Post', 'has been completed.');
        });
      } else {
        showErrorPopup(context, 'Couldn\'t post', result);
      }
    } else {
      showErrorPopup(
        context,
        'No Image Selected',
        'Please select an image to upload.',
      );
    }

    setState(() {
      isLoading = false; // Set loading to false when post creation finishes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateFormTopWidget(
                  title: 'Create New Post',
                  imagePath: 'assets/post/createNewPost.png'),
              const EventInfoAlert(
                alertText:
                    "Enter the post name, creative title and a small description of the post, and upload an image for the post.",
              ),
              const SizedBox(height: 20),
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '📝 Your creative title 🌍',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorTheme.lightGreen1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Post description',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorTheme.lightGreen1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Image Upload',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_image != null)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(File(_image!.path)),
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
              GradientButton(
                text: 'Create Post',
                onTap: () {
                  if (!isLoading) {
                    _createPost(); // Call the function if not loading
                  }
                },
                isLoading: isLoading, // Pass the loading state to the button
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
