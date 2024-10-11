import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';

void showQrCodePopup(BuildContext context, Map<String, dynamic> eventData) {
  String qrData = eventData['eventId'].toString(); // Customize as needed

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: ColorTheme.white,
        content: SingleChildScrollView(
          // Enable scrolling if content exceeds available height
          child: Container(
            width: 300, // Set a fixed width for the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Event Join QR Code',
                  style: TextStyle(
                    color: ColorTheme.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 240, // Size of the QR code
                  gapless: false,
                  // embeddedImage: const AssetImage(
                  //     'assets/logo/logo_without_name.png'), // Make sure the asset path is correct
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(80, 80),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.lightBlue1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
