import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureSection extends StatelessWidget {
  final String photoUrl; // Accept photoUrl as a parameter
  final Function(File) onImageSelected; // Accept onImageSelected as a parameter

  const ProfilePictureSection({
    Key? key,
    required this.photoUrl,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : const NetworkImage('https://via.placeholder.com/150'), // Placeholder
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () async {
                  File? selectedImage = await _selectImage();
                  if (selectedImage != null) {
                    onImageSelected(selectedImage); // Notify the parent widget
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<File?> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }
}
