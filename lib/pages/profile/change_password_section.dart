import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/common/GradientButton.dart';
import 'edit_profile.dart'; // Import the file where TextFieldWidget is defined

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({Key? key}) : super(key: key);

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
