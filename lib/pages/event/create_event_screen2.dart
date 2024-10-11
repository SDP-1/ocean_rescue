import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/map/location_picker.dart';

class CreateEventScreen2 extends StatefulWidget {
  final String eventName;
  final String description;
  final String image;
  final int groupSize;

  const CreateEventScreen2({
    super.key,
    required this.eventName,
    required this.description,
    required this.image,
    required this.groupSize,
  });

  @override
  _CreateEventScreen2State createState() => _CreateEventScreen2State();
}

class _CreateEventScreen2State extends State<CreateEventScreen2> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final int _selectedHours = 0;
  final int _selectedMinutes = 0;
  double? _latitude;
  double? _longitude;

  // Example of your existing validation method
  void _validateAndSaveEvent() {
    // Add validation logic here
    if (_latitude != null && _longitude != null) {
      _saveEvent('Your Location String Here');
    } else {
      // Show error for location selection
      showErrorPopup(context, 'Please select a location.', 'Error');
    }
  }

  void _saveEvent(String location) async {
    DateTime date = _selectedDate ?? DateTime.now();
    String startTime = _startTime?.format(context) ?? 'Not Set';
    String endTime = _endTime?.format(context) ?? 'Not Set';
    String duration = '$_selectedHours Hours and $_selectedMinutes Minutes';

    try {
      // Add your logic to save the event here
      print('Event saved with location: ($location), Lat: $_latitude, Lon: $_longitude');

      // Navigate back or show success message
      Navigator.pop(context);
      // Replace with your actual event screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventScreen(),
        ),
      );
      showSuccessPopup(context, 'Event created successfully!', 'Success');
    } catch (e) {
      print("Error saving event: $e");
      showErrorPopup(context, 'Failed to create event: $e', 'Error');
    }
  }

  // Dummy methods for time and date picker
  Widget _buildDateTimePicker() {
    // Add your date and time picker UI here
    return Container();
  }

  Widget _buildCustomDurationPicker() {
    // Add your duration picker UI here
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'assets/logo/logo_without_name.png',
          height: 40,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your header widget here
            const SizedBox(height: 20),
            _buildDateTimePicker(),
            const SizedBox(height: 20),
            _buildCustomDurationPicker(),
            const SizedBox(height: 20),
            LocationPicker(
              onLocationSelected: (latitude, longitude) {
                setState(() {
                  _latitude = latitude;
                  _longitude = longitude;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _validateAndSaveEvent();
              },
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }

  void showErrorPopup(BuildContext context, String message, String title) {
    // Implement your error popup
  }

  void showSuccessPopup(BuildContext context, String message, String title) {
    // Implement your success popup
  }
}

// Dummy EventScreen widget, replace with your actual event screen
class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Screen')),
      body: const Center(child: Text('Event created!')),
    );
  }
}
