import 'package:cloud_firestore/cloud_firestore.dart';

class EventFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a singleton instance
  static final EventFirestoreMethods instance = EventFirestoreMethods._internal();

  EventFirestoreMethods._internal(); // Private constructor

  /// Method to create a new event in Firestore.
  Future<void> createEvent({
    required String eventName,
    required String description,
    required String location,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String groupSize,
    required String imageUrl,
    required int duration, // Duration in minutes
  }) async {
    try {
      await _firestore.collection('events').add({
        'event_name': eventName,
        'description': description,
        'location': location,
        'date': date.toIso8601String(), // Store date as string
        'start_time': startTime,
        'end_time': endTime,
        'group_size': groupSize,
        'image_url': imageUrl,
        'duration': duration,
      });
      print('Event created successfully');
    } catch (e) {
      print('Error creating event: $e');
      throw Exception('Failed to create event: $e');
    }
  }
}
