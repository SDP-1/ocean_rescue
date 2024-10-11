import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import for handling images
import 'package:zxing2/qrcode.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result; // Stores scanned data from the camera
  String? galleryResult; // Stores scanned data from the gallery
  QRViewController? controller; // Controller for the camera QR scanner
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Key for the QR view

  final ImagePicker _picker =
      ImagePicker(); // Image picker for selecting images from gallery

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed:
                _scanFromGallery, // Trigger gallery selection for QR scanning
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)), // Camera QR view
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Text('Scanned Data from Camera: ${result!.code}')
                  : galleryResult != null
                      ? Text('Scanned Data from Gallery: $galleryResult')
                      : const Text(
                          'Scan a code or select an image from gallery'),
            ),
          )
        ],
      ),
    );
  }

  // Build QR View for camera scanning
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated, // Setup the camera QR scanner
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  // Handle QRView creation for camera scanning
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  // Handle camera permission setting
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  // Scan QR code from the gallery using zxing2 and image package
  Future<void> _scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes =
            await File(image.path).readAsBytes(); // Load image as bytes
        final img.Image? imageData = img.decodeImage(bytes); // Decode the image

        if (imageData != null) {
          // Convert the image to grayscale luminance source
          final luminanceSource = RGBLuminanceSource(
            imageData.width,
            imageData.height,
            Int32List.fromList(imageData
                .getBytes(format: img.Format.luminance)
                .map((e) => e.toInt())
                .toList()),
          );
          final binaryBitmap = BinaryBitmap(HybridBinarizer(luminanceSource));
          final reader = QRCodeReader();
          final qrCode = reader.decode(binaryBitmap); // Decode the QR code

          setState(() {
            galleryResult = qrCode.text; // Display result from gallery
          });
        } else {
          throw Exception('Failed to decode image.');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to extract QR code: $e')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
