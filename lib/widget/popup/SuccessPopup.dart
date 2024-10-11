import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

void showSuccessPopup(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: ColorTheme
            .white, // Background color similar to DeleteConfirmationPopup
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                color: ColorTheme.black, // black text color
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Message
            Text(
              message,
              style: const TextStyle(
                color: ColorTheme.black, // black text color
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Success Icon/Image
            Image.asset('assets/popup/Success.png', width: 80, height: 80),
            const SizedBox(height: 20),
            // Button
            SizedBox(
              width: 200, // Fixed width for button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close popup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF00C3A9), // Button color similar to "Cancel" in DeleteConfirmationPopup
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Let\'s Go',
                  style: TextStyle(
                    color: ColorTheme
                        .black, // Text color matching the style of DeleteConfirmationPopup
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
