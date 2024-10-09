import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/widget/common/CreateFormTopWidget.dart';
import 'package:ocean_rescue/widget/common/GradientButton.dart';
import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';

class CreateEventScreen2 extends StatefulWidget {
  @override
  _CreateEventScreen2State createState() => _CreateEventScreen2State();
}

class _CreateEventScreen2State extends State<CreateEventScreen2> {
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _recurrence = 'Weekly';
  List<bool> _selectedDays =
      List.generate(7, (index) => false); // 7 days for the week

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _pickEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
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
            CreateFormTopWidget(
              title: 'Create New Event P2',
              imagePath: 'assets/post/createNewPost.png',
            ),
            EventInfoAlert(
              alertText:
                  "Enter the basic details describing the location, time, date, and the recurrence of the event.",
            ),
            const SizedBox(height: 20),
            _buildDateTimePicker(),
            const SizedBox(height: 20),
            _buildRecurrencePicker(),
            const SizedBox(height: 20),
            _buildDaySelection(),
            const SizedBox(height: 20),
            _buildLocationInput(),
            const SizedBox(height: 20),
            _buildMapView(),
            const SizedBox(height: 30),
            GradientButton(
              text: 'Create Event',
              onTap: () {
                // Add navigation code
              },
              width: double.infinity, // Set width to take full width
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  // Date and Time Picker
  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Date',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedDate != null
                      ? DateFormat.yMMMd().format(_selectedDate!)
                      : "00/00/0000",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  _startTime != null && _endTime != null
                      ? "${_startTime!.format(context)} - ${_endTime!.format(context)}"
                      : "13:00 PM → 16:00 PM",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                await _pickDateTime();
                await _pickStartTime();
                await _pickEndTime();
              },
              icon: const Icon(Icons.calendar_today_outlined),
            ),
          ],
        ),
      ],
    );
  }

// Recurrence Picker
  Widget _buildRecurrencePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
      crossAxisAlignment: CrossAxisAlignment.center, // Center align vertically
      children: [
        const Text(
          'Recurrence',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight, // Align dropdown to the right
            child: Container(
              width: 120, // Set a specific width for the dropdown
              child: DropdownButton<String>(
                value: _recurrence,
                onChanged: (String? newValue) {
                  setState(() {
                    _recurrence = newValue!;
                  });
                },
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true, // Ensure dropdown expands
                underline: Container(
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Day Selection
  Widget _buildDaySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Days',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 days in a week
            childAspectRatio: 1.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDays[index] = !_selectedDays[index];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedDays[index]
                      ? ColorTheme.lightBlue1
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Center(
                  child: Text(
                    dayLabels[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedDays[index] ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Location Input
  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Location',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            hintText: 'Search Location',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: ColorTheme.lightGreen1,
          ),
        ),
      ],
    );
  }

  // Map View (static for now)
  Widget _buildMapView() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Image.asset(
        'assets/event/map.png', // Placeholder for map image
        fit: BoxFit.cover,
      ),
    );
  }
}
