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
        backgroundColor: ColorTheme.darkBlue2,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: ColorTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                color: ColorTheme.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset('assets/popup/Success.png', width: 80, height: 80),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C3A9), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Let\'s Go',
                  style: TextStyle(
                    color: ColorTheme.black, // Replace with your desired color
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
