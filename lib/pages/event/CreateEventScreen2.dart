// import 'package:flutter/material.dart';
// import 'package:ocean_rescue/theme/colorTheme.dart';
// import 'package:intl/intl.dart';
// import 'package:ocean_rescue/widget/common/CreateFormTopWidget.dart';
// import 'package:ocean_rescue/widget/common/GradientButton.dart';
// import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';

// class CreateEventScreen2 extends StatefulWidget {
//   @override
//   _CreateEventScreen2State createState() => _CreateEventScreen2State();
// }

// class _CreateEventScreen2State extends State<CreateEventScreen2> {
//   final TextEditingController _locationController = TextEditingController();
//   DateTime? _selectedDate;
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   int _selectedHours = 0;
//   int _selectedMinutes = 0;

//   Future<void> _pickDateTime() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _pickStartTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _startTime = pickedTime;
//       });
//     }
//   }

//   Future<void> _pickEndTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         _endTime = pickedTime;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Image.asset(
//           'assets/logo/logo_without_name.png',
//           height: 40,
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(25.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CreateFormTopWidget(
//               title: 'Create New Event P2',
//               imagePath: 'assets/post/createNewPost.png',
//             ),
//             EventInfoAlert(
//               alertText:
//                   "Enter the basic details describing the location, time, date, and the duration of the event.",
//             ),
//             const SizedBox(height: 20),
//             _buildDateTimePicker(),
//             const SizedBox(height: 20),
//             _buildCustomDurationPicker(), // Add custom duration picker here
//             const SizedBox(height: 20),
//             _buildLocationInput(),
//             const SizedBox(height: 20),
//             _buildMapView(),
//             const SizedBox(height: 30),
//             GradientButton(
//               text: 'Create Event',
//               onTap: () {
//                 // Add navigation code
//               },
//               width: double.infinity, // Set width to take full width
//               height: 50.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Date and Time Picker
//   Widget _buildDateTimePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Event Date',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _selectedDate != null
//                       ? DateFormat.yMMMd().format(_selectedDate!)
//                       : "00/00/0000",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   _startTime != null && _endTime != null
//                       ? "${_startTime!.format(context)} - ${_endTime!.format(context)}"
//                       : "13:00 PM → 16:00 PM",
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//             IconButton(
//               onPressed: () async {
//                 await _pickDateTime();
//                 await _pickStartTime();
//                 await _pickEndTime();
//               },
//               icon: const Icon(Icons.calendar_today_outlined),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Custom Duration Picker
//   Widget _buildCustomDurationPicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Event Duration',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 const Text("Hours",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: _selectedHours > 0
//                           ? () {
//                               setState(() {
//                                 _selectedHours--;
//                               });
//                             }
//                           : null,
//                       icon: const Icon(Icons.remove),
//                     ),
//                     Text('$_selectedHours',
//                         style: const TextStyle(fontSize: 20)),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _selectedHours++;
//                         });
//                       },
//                       icon: const Icon(Icons.add),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 const Text("Minutes",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: _selectedMinutes >= 5
//                           ? () {
//                               setState(() {
//                                 _selectedMinutes -= 5;
//                               });
//                             }
//                           : null,
//                       icon: const Icon(Icons.remove),
//                     ),
//                     Text('$_selectedMinutes',
//                         style: const TextStyle(fontSize: 20)),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _selectedMinutes = (_selectedMinutes + 5) % 60;
//                         });
//                       },
//                       icon: const Icon(Icons.add),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // Location Input
//   Widget _buildLocationInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Event Location',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: _locationController,
//           decoration: InputDecoration(
//             hintText: 'Search Location',
//             prefixIcon: const Icon(Icons.search),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             filled: true,
//             fillColor: ColorTheme.lightGreen1,
//           ),
//         ),
//       ],
//     );
//   }

//   // Map View (static for now)
//   Widget _buildMapView() {
//     return Container(
//       height: 180,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Image.asset(
//         'assets/event/map.png', // Placeholder for map image
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ocean_rescue/resources/event_firestor_methods.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/widget/common/CreateFormTopWidget.dart';
import 'package:ocean_rescue/widget/common/GradientButton.dart';
import 'package:ocean_rescue/widget/event/EventInfoAlert.dart';

class CreateEventScreen2 extends StatefulWidget {
  final String eventName;
  final String description;
  final String imagePath;
  final String groupSize;

  CreateEventScreen2({
    required this.eventName,
    required this.description,
    required this.imagePath,
    required this.groupSize,
  });

  @override
  _CreateEventScreen2State createState() => _CreateEventScreen2State();
}

class _CreateEventScreen2State extends State<CreateEventScreen2> {
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _selectedHours = 0;
  int _selectedMinutes = 0;

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
                  "Enter the basic details describing the location, time, date, and the duration of the event.",
            ),
            const SizedBox(height: 20),
            _buildDateTimePicker(),
            const SizedBox(height: 20),
            _buildCustomDurationPicker(),
            const SizedBox(height: 20),
            _buildLocationInput(),
            const SizedBox(height: 20),
            _buildMapView(),
            const SizedBox(height: 30),
            GradientButton(
              text: 'Create Event',
              onTap: () {
                // Call method to save event to database
                _saveEvent();
              },
              width: double.infinity,
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

  // Custom Duration Picker
  Widget _buildCustomDurationPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Duration',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text("Hours",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      onPressed: _selectedHours > 0
                          ? () {
                              setState(() {
                                _selectedHours--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$_selectedHours',
                        style: const TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedHours++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Text("Minutes",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      onPressed: _selectedMinutes >= 5
                          ? () {
                              setState(() {
                                _selectedMinutes -= 5;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$_selectedMinutes',
                        style: const TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedMinutes = (_selectedMinutes + 5) % 60;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _saveEvent() async {
    String location = _locationController.text;
    DateTime date = _selectedDate ?? DateTime.now();
    String startTime = _startTime?.format(context) ?? 'Not Set';
    String endTime = _endTime?.format(context) ?? 'Not Set';
    String duration = '$_selectedHours Hours and $_selectedMinutes Minutes';

    try {
      // Ensure all parameters are valid
      await EventFirestoreMethods.instance.createEvent(
        eventName: widget.eventName,
        description: widget.description,
        location: location,
        date: date,
        startTime: startTime,
        endTime: endTime,
        groupSize: widget.groupSize,
        imageUrl: widget.imagePath,
        duration: _selectedHours * 60 + _selectedMinutes,
      );

      // Navigate back or show success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully!')),
      );
    } catch (e) {
      print("Error saving event: $e"); // Print detailed error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $e')),
      );
    }
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
