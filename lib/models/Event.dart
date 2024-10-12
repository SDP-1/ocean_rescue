import 'package:flutter/material.dart';
import 'package:ocean_rescue/models/participant.dart';

class Event {
  String eventId;
  String uid;
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
  List<Participant> participants; // Add a list of participants

  // Constructor
  Event({
    required this.uid,
    required this.eventId,
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
    this.participants = const [], // Initialize participants as an empty list
  }) : duration = _calculateDuration(startTime, endTime);

  // Method to calculate event duration in hours as a double (e.g., 3.5 hours)
  static double _calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    final totalMinutes = endMinutes - startMinutes;
    return totalMinutes / 60.0; // Convert minutes to hours
  }

  // Method to add a participant to the event
  void addParticipant(Participant participant) {
    participants.add(participant);
  }
}
