import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/common/GradientButton.dart';
import '../../resources/profile_firestore_methods.dart';
import 'bio_field_widget.dart';
import 'change_password_section.dart'; // Import ChangePasswordSection
import 'package:ocean_rescue/resources/auth_methods.dart'; // Import your auth methods
import 'package:ocean_rescue/models/user.dart';
import 'email_display_box.dart'; // Import your User model if needed
import '../../resources/profile_firestore_methods.dart';
import 'profile_picture.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showChangePassword = false; // Tracks whether the password section is visible
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(); // Add a controller for bio
  String email = ""; // Store email retrieved from Firestore
  String photoUrl = ""; // Store photo URL retrieved from Firestore
  File? _selectedImage; // To hold the selected image file

  @override
  void initState() {
    super.initState();
    _fetchEmail(); // Fetch email when the widget initializes
    _fetchUserDetails(); // Fetch username and bio when the widget initializes
  }

  // Fetch email from Firestore
  Future<void> _fetchEmail() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("Current User UID: $uid"); // Print the UID to see if it's loaded
    String fetchedEmail = await ProfileFirestoreMethods().getEmailByUid(uid);
    print("Fetched Email: $fetchedEmail"); // Print the fetched email

    setState(() {
      email = fetchedEmail;
    });
  }

  // Fetch user details (username, bio, and photo URL) from Firestore
  Future<void> _fetchUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("Current User UID: $uid"); // Print the UID to see if it's loaded

    // Call the updated method to fetch username, bio, and photoUrl
    Map<String, dynamic> fetchedDetails = await ProfileFirestoreMethods().getUserDetailsByUid(uid);
    
    print("Fetched Username: ${fetchedDetails['username']}"); // Print the fetched username
    print("Fetched Bio: ${fetchedDetails['bio']}"); // Print the fetched bio
    print("Fetched Photo URL: ${fetchedDetails['photoUrl']}"); // Print the fetched photo URL

    setState(() {
      _usernameController.text = fetchedDetails['username'] ?? ""; // Update username controller
      _bioController.text = fetchedDetails['bio'] ?? ""; // Update bio controller
      photoUrl = fetchedDetails['photoUrl'] ?? ""; // Store photo URL for later use
    });
  }

  // Save the updated username, bio, and photo URL
  Future<void> _saveDetails() async {
    String username = _usernameController.text;
    String bio = _bioController.text;

    String updatedPhotoUrl = photoUrl; // By default, use the existing photo URL
    if (_selectedImage != null) {
      updatedPhotoUrl = await _uploadImageToFirebase(_selectedImage!); // Upload new image and get URL
    }

    String response = await ProfileFirestoreMethods().updateUsernameBioAndPhoto(
      username: username,
      bio: bio,
      photoUrl: updatedPhotoUrl, // Save the updated photo URL
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToFirebase(File image) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Reference storageRef = FirebaseStorage.instance.ref().child('profilePics').child(uid);

    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL(); // Get the download URL after upload
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePictureSection(
              photoUrl: photoUrl,
              // onImageSelected: (File image) {
              //   setState(() {
              //     _selectedImage = image; // Store the selected image
              //   });
              // },
            ), // Pass photoUrl and onImageSelected to the ProfilePictureSection
            // Pass photoUrl to the ProfilePictureSection
            const SizedBox(height: 20),
            UserDetailsForm(
              usernameController: _usernameController,
              bioController: _bioController,
              email: email, // Pass email to the form
            ),
            const SizedBox(height: 20),
            GradientButton(
              text: 'Save Details',
              onTap: _saveDetails, // Call the save details method
              width: double.infinity, // Full-width button
              height: 50.0,
            ), // Save details button
            const SizedBox(height: 20),

            // Toggle to show/hide the "Change Password" section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Do you want to change your password?"),
                Switch(
                  value: showChangePassword,
                  onChanged: (value) {
                    setState(() {
                      showChangePassword = value; // Update the state when the switch is toggled
                    });
                  },
                ),
              ],
            ),

            // Conditionally render the ChangePasswordSection based on the state
            if (showChangePassword) const ChangePasswordSection(),
          ],
        ),
      ),
    );
  }
}

class ProfilePictureSection extends StatelessWidget {
  final String photoUrl; // Accept photoUrl as a parameter

  const ProfilePictureSection({Key? key, required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            // Profile picture (using the fetched photoUrl or a placeholder if it's empty)
            CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl.isNotEmpty 
                  ? NetworkImage(photoUrl) 
                  : const NetworkImage('https://via.placeholder.com/150'), // Use fetched photoUrl or placeholder image
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // Handle profile picture change
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class UserDetailsForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController bioController; // Add bio controller
  final String email;

  const UserDetailsForm({
    Key? key,
    required this.usernameController,
    required this.bioController,
    required this.email, // Accept email as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          label: "Username",
          controller: usernameController, // Pass the controller
        ),
        const SizedBox(height: 16),
       BioFieldWidget(controller: bioController), // Use BioFieldWidget instead
        const SizedBox(height: 16),
        EmailDisplayBox(email: email),
      ],
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  final bool isEmailField;
  final bool enabled;
  final TextEditingController? controller;
  final String? initialValue; // For setting initial value
  final String? email; // For displaying email as plain text

  const TextFieldWidget({
    Key? key,
    required this.label,
    this.isEmailField = false,
    this.enabled = true,
    this.controller,
    this.initialValue,
    this.email, // Accept email as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Check if it's an email field and display as plain text if so
        isEmailField && email != null
            ? Text(
                email!,
                style: const TextStyle(fontSize: 14, color: Colors.black), // Style as needed
              )
            : TextField(
                controller: controller,
                keyboardType: isEmailField ? TextInputType.emailAddress : TextInputType.text,
                enabled: enabled,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: enabled ? Colors.white : Colors.grey[200],
                ),
                // Set initial value if provided
                onChanged: (value) {
                  if (initialValue != null) {
                    controller?.text = initialValue!;
                  }
                },
              ),
      ],
    );
  }
}
