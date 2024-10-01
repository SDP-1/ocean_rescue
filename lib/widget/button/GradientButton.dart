import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final TextStyle? textStyle; // Add this property to customize text style

  const GradientButton({
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.height = 50.0,
    this.textStyle, // Initialize the textStyle parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF08BDBD), Color(0xFF1877F2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle ?? const TextStyle(
            color: Colors.white,
            fontSize: 16, // Default font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
