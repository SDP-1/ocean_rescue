import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocean_rescue/pages/feed/feed_screen.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/popup/ErrorPopup.dart';
import 'package:ocean_rescue/widget/popup/SuccessPopup.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _image;

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId;
  String? username;

  @override
  void initState() {
    super.initState();
    _getCurrentUserDetails();
  }

  Future<void> _getCurrentUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;

      // Fetch user details from Firestore (assumes user data is stored under 'users' collection)
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      setState(() {
        username = userDoc['username'];
      });
    }
  }

  // Function to pick an image from gallery or camera
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = image;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
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

  // Function to create a new post
  Future<void> _createPost() async {
    if (_image == null) {
      showErrorPopup(context, 'Image missing', 'Please upload an image.');
      return;
    }
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      showErrorPopup(context, 'Fields empty', 'Please fill in all fields.');
      return;
    }

    try {
      // Generate unique post ID using uuid
      String postId = Uuid().v4();

      // save the date
      Timestamp datePublished = Timestamp.now();

      // Upload image to Firebase Storage and get the download URL
      String postUrl = await _uploadImageToStorage(postId);

      // Create the post object with details
      Map<String, dynamic> post = {
        'postId': postId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'uid': userId, // Use the logged-in user's UID
        'username': username, // Use the logged-in user's username
        'likes': [], // Store the list of users who liked the post
        'postUrl': postUrl,
        'datePublished': datePublished, // Use the Timestamp
      };

      // Save post to Firestore
      await _firestore.collection('posts').doc(postId).set(post);

      // Show success popup
      showSuccessPopup(context, 'Post Created', 'Your post has been created.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FeedScreen()),
      );
    } catch (e) {
      showErrorPopup(context, 'Post Creation Failed', e.toString());
    }
  }

  // Upload the image to Firebase Storage
  Future<String> _uploadImageToStorage(String postId) async {
    Reference ref = _storage.ref().child('posts').child('$postId.jpg');
    UploadTask uploadTask = ref.putFile(File(_image!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
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
        // Added to make the content scrollable
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF08BDBD),
                      Color(0xFF1877F2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
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
                        'Create New Post',
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
              const SizedBox(height: 15),
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '📝 Your creative title 🌍',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorTheme.liteGreen1,
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
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: ColorTheme.liteGreen1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF08BDBD),
                      Color(0xFF1877F2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: _createPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Create Post',
                    style: TextStyle(fontSize: 18, color: ColorTheme.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
