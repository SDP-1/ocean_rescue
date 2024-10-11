import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

void DeleteConfirmationPopup(
    BuildContext context, String message, Function onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: ColorTheme.white, // Use your preferred color
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title text
            const Text(
              'Are you sure that you want to',
              style: TextStyle(
                color: ColorTheme.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Emphasized DELETE text
            const Text(
              'DELETE',
              style: TextStyle(
                color: ColorTheme.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Main message text
            Text(
              message,
              style: const TextStyle(
                color: ColorTheme.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Icon (custom asset or default Flutter icon)
            Image.asset('assets/popup/info.png', width: 80, height: 80),
            const SizedBox(height: 20),
            // Button Column for Confirm and Cancel
            Column(
              children: [
                SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onConfirm(); // Call the deletion logic
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Confirm',
                        style: TextStyle(
                            color: Colors.white)), // Set text color to white
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Red color for delete action
                      padding: const EdgeInsets.symmetric(
                          vertical: 10), // Adjust padding if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between buttons
                SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    }, // Set text color to dark blue
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C3A9),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10), // Adjust padding if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(
                            color: ColorTheme
                                .black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
