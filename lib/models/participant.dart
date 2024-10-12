import 'package:flutter/material.dart';

class Participant {
  String userId;
  TimeOfDay startTime; // Time when the participant joined
  TimeOfDay endTime; // End time of the event
  double duration; // Duration of participation in hours
  int earnedExp; // Experience points earned

  // Constructor to initialize the participant with current start time and event's end time
  Participant({
    required this.userId,
    required this.startTime,
    required TimeOfDay eventEndTime,
  })  : endTime = eventEndTime, // Assign event end time
        duration = _calculateDuration(startTime, eventEndTime), // Calculate duration
        earnedExp = _calculateExp(startTime, eventEndTime); // Calculate experience points

  // Method to calculate duration in hours as a double (e.g., 3.5 hours)
  static double _calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    final totalMinutes = endMinutes - startMinutes;
    return totalMinutes / 60.0; // Convert minutes to hours
  }

  // Method to calculate earned experience points based on time (1 min = 1 exp)
  static int _calculateExp(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    final totalMinutes = endMinutes - startMinutes;
    return totalMinutes; // 1 min = 1 exp, so return total minutes as exp
  }

  // Method to convert Participant to a JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'duration': duration,
      'earnedExp': earnedExp,
    };
  }
}
