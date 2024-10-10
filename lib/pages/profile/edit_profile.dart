import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/common/GradientButton.dart';
import '../../resources/profile_firestore_methods.dart';
import 'change_password_section.dart'; // Import ChangePasswordSection
import 'package:ocean_rescue/resources/auth_methods.dart'; // Import your auth methods
import 'package:ocean_rescue/models/user.dart';

import 'email_display_box.dart'; // Import your User model if needed

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

  @override
  void initState() {
    super.initState();
    _fetchEmail(); // Fetch email when the widget initializes
  }

  Future<void> _fetchEmail() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print("Current User UID: $uid"); // Print the UID to see if it's loaded

    String fetchedEmail = await ProfileFirestoreMethods().getEmailByUid(uid);
    print("Fetched Email: $fetchedEmail"); // Print the fetched email

    setState(() {
      email = fetchedEmail;
    });
  }

  void _saveDetails() async {
    String username = _usernameController.text;
    String bio = _bioController.text;
    String response = await ProfileFirestoreMethods().updateUsernameAndBio(username: username, bio: bio);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response))); // Show response message
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
            const ProfilePictureSection(), // Profile Picture Section
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
  const ProfilePictureSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            // Profile picture (using a placeholder for now)
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
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
        TextFieldWidget(
          label: "Bio",
          controller: bioController, // Pass the controller
        ),
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

