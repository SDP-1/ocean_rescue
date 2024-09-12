import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

void showErrorPopup(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: ColorTheme.lightRed,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: ColorTheme.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                color: ColorTheme.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/popup/Error.png',
              width: 80,
              height: 80,
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.red, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: ColorTheme.black, // Button text color
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
