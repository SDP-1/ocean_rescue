import 'package:flutter/material.dart';

class Event {
  String eventName;
  String description;
  String? location;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  double duration;
  String imagePath;
  String groupSize;
  double? latitude;
  double? longitude;
  int? priority;

  // Constructor
  Event({
    required this.eventName,
    required this.description,
    this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.imagePath,
    required this.groupSize,
    this.latitude,
    this.longitude,
    this.priority,
  }) : duration = _calculateDuration(startTime, endTime);

  // Method to calculate duration in hours as a double (e.g., 3.5 hours)
  static double _calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    final totalMinutes = endMinutes - startMinutes;
    return totalMinutes / 60.0; // Convert minutes to hours
  }
}
