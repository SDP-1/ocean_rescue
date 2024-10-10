import 'package:flutter/material.dart';

class CreateFormTopWidget extends StatelessWidget {
  final String title; // Title text
  final String imagePath; // Image asset path

  const CreateFormTopWidget({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
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
                  imagePath,
                  height: 70,
                  width: 70,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0), // Set the left padding here
                  child: Text(
                    // The title text passed from the parent widget
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
