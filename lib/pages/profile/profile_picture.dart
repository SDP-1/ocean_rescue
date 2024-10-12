import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

class ProfilePictureSection extends StatelessWidget {
  final String photoUrl;
  final Function(File) onImageSelected;

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
                  : const NetworkImage('https://via.placeholder.com/150'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () async {
                  final File? image = await _selectImage();
                  if (image != null) {
                    onImageSelected(image);
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
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
