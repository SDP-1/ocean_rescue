import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

void showDeleteConfirmationPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners for the pop-up
        ),
        backgroundColor: ColorTheme.darkBlue2, // Dark blue background
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ensure the pop-up size fits the content
          children: [
            // Main title text
            const Text(
              'Are you sure that you want to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            // DELETE text with emphasis
            const Text(
              'DELETE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Subtitle text
            const Text(
              'the reported dump?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Info Icon in a circle
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorTheme.liteGray, // Background for the icon circle
              ),
              child: Center(
                child: Image.asset(
                  'assets/popup/info.png', // Your info icon path
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Confirm and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Confirm button with a red background
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your delete action logic here
                    Navigator.of(context).pop(); // Close the pop-up
                  },
                  icon: const Icon(Icons.delete, color: ColorTheme.white), // Delete icon
                  label: const Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.red, // Red color for confirm button
                    minimumSize: const Size(100, 40), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spacing between buttons
                // Cancel button with cyan background
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the pop-up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.cyan, // Cyan color for cancel button
                    minimumSize: const Size(100, 40), // Button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
