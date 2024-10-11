import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/resources/auth_methods.dart';
import 'package:ocean_rescue/resources/event_firestor_methods.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ocean_rescue/models/participant.dart';
import 'package:permission_handler/permission_handler.dart';
import '../event/ParticipationConfirmationPopup.dart'; // Import your popup dialog

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result; // Stores scanned data from the camera
  QRViewController? controller; // Controller for the camera QR scanner
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Key for the QR view
  final AuthMethods _auth = AuthMethods(); // Instance of authentication methods
  bool isLoading = false; // To track loading state

  @override
  void initState() {
    super.initState();
    _checkCameraPermissions(); // Check for camera permissions on init
  }

  Future<void> _checkCameraPermissions() async {
    if (await Permission.camera.request().isGranted) {
      // If permission is granted, do nothing
    } else {
      // Handle the case when permission is denied
      _showSnackBar('Camera permission is required to scan QR codes.');
      Navigator.pop(context); // Close the QR scanner if permission is denied
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera(); // Pause camera if reassembled on Android
    }
    controller?.resumeCamera(); // Resume camera on reassemble
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'), // App bar title
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)), // Camera QR view
          Expanded(
            flex: 1,
            child: Center(
              child: result != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Scanned Data: ${result!.code}'),
                        ElevatedButton(
                          onPressed: () => _showConfirmationDialog(
                              result!.code!), // Show confirmation dialog
                          child: const Text('Add Participant'),
                        ),
                      ],
                    )
                  : const Text('Scan a code to add participant'),
            ),
          ),
          if (isLoading) // Show loading indicator while adding participant
            const CircularProgressIndicator(),
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
    );
  }

  // Handle QRView creation for camera scanning
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    // Listen for scanned data
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData; // Store scanned data
      });
    });
  }

  // Show confirmation dialog before adding participant
  void _showConfirmationDialog(String eventId) {
    ParticipationConfirmationPopup(
      context,
      eventId,
      () => _addParticipant(eventId), // Call add participant if confirmed
    );
  }

  // Add participant to the event in Firestore after fetching event details
  Future<void> _addParticipant(String eventId) async {
    if (!mounted) return; // Check if the widget is still mounted

    setState(() {
      isLoading = true; // Start loading
    });

    try {
      // Fetch event details to verify if the scanned event ID is valid
      final eventData =
          await EventFirestoreMethods.instance.getEventById(eventId);

      // Check if the event was found
      if (eventData == null) {
        _showSnackBar(
            'Event not found or invalid event ID.'); // Show error if not found
        return;
      }

      // Get the current time for the start time of the participant
      final currentTime = TimeOfDay.now();

      // Ensure end time from the event data is valid
      TimeOfDay eventEndTime =
          _parseTimeOfDay(eventData['end_time']); // Parse the end time

      // Create a new Participant with the current time as start time
      Participant newParticipant = Participant(
        userId: _auth.getCurrentUserId()!, // Replace with actual user ID
        startTime: currentTime, // Set current time as start time
        eventEndTime: eventEndTime, // Set end time from event data
      );

      // Add participant to Firestore
      await EventFirestoreMethods.instance.addParticipant(
        context, // Pass context for snackbar display
        eventId, // Pass the scanned event ID
        newParticipant, // Pass the newParticipant object
      );

      _showSnackBar('Participant added successfully!'); // Show success message
    } catch (e) {
      // Handle any errors during the process
      _showSnackBar('Failed to add participant: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  // Utility method to display SnackBar messages
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)), // Display the message
      );
    }
  }

  // Utility method to parse a time string into TimeOfDay
  TimeOfDay _parseTimeOfDay(String time) {
    // Split the time string by space to separate time from AM/PM
    List<String> parts = time.split(' ');
    if (parts.length != 2) {
      throw FormatException('Invalid time format: $time');
    }

    // Split the time part into hours and minutes
    List<String> timeParts = parts[0].split(':');
    if (timeParts.length != 2) {
      throw FormatException('Invalid time format: $time');
    }

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Handle AM/PM format
    if (parts[1].toUpperCase() == 'PM' && hour != 12) {
      hour += 12; // Convert PM hour to 24-hour format
    } else if (parts[1].toUpperCase() == 'AM' && hour == 12) {
      hour = 0; // Midnight case
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose of the controller
    super.dispose();
  }
}
