import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/common/GradientButton.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showChangePassword =
      false; // Tracks whether the password section is visible

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
            const UserDetailsForm(), // Username, Full name, Email form
            const SizedBox(height: 20),
            GradientButton(
              text: 'Save Details',
              onTap: () {
                // Add your save details logic
              },
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
                      showChangePassword =
                          value; // Update the state when the switch is toggled
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
  const ProfilePictureSection({super.key});

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
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Placeholder image
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
  const UserDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(label: "Username"),
        SizedBox(height: 16),
        TextFieldWidget(label: "Full name"),
        SizedBox(height: 16),
        TextFieldWidget(
          label: "Email",
          isEmailField: true,
          enabled: false, // Disabling email field as shown in the design
        ),
      ],
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  final bool isEmailField;
  final bool enabled;

  const TextFieldWidget({
    super.key,
    required this.label,
    this.isEmailField = false,
    this.enabled = true,
  });

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
        TextField(
          keyboardType:
              isEmailField ? TextInputType.emailAddress : TextInputType.text,
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
        ),
      ],
    );
  }
}

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change password',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const TextFieldWidget(label: "Current password"),
          const SizedBox(height: 16),
          const TextFieldWidget(label: "New password"),
          const SizedBox(height: 16),
          GradientButton(
            text: 'Change Password',
            onTap: () {
              // Add your change password logic
            },
            width: double.infinity, // Full-width button
            height: 50.0,
          ),
        ],
      ),
    );
  }
}
