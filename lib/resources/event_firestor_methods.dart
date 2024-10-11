import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ocean_rescue/resources/auth_methods.dart';
import 'package:ocean_rescue/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class EventFirestoreMethods {
  final AuthMethods _auth = AuthMethods();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a singleton instance
  static final EventFirestoreMethods instance =
      EventFirestoreMethods._internal();

  EventFirestoreMethods._internal(); // Private constructor

  // Compress the image to ensure it's less than 2MB
  Future<Uint8List> _compressImage(Uint8List file) async {
    // Check if the image is larger than 1MB
    if (file.lengthInBytes <= .5 * 1024 * 1024) {
      // If the image is already below .5MB, return the original image
      return file;
    }

    // Compress the image using flutter_image_compress if it's larger than .5MB
    Uint8List? compressedImage = await FlutterImageCompress.compressWithList(
      file,
      minWidth: 1080, // Adjust width and height as needed
      minHeight: 1080,
      quality: 80, // Adjust quality, lower quality for smaller size
    );

    if (compressedImage != null &&
        compressedImage.lengthInBytes <= 1 * 1024 * 1024) {
      return compressedImage;
    }
    // If compression doesn't reduce the size enough, return the original image
    return file;
  }

  // Upload image and return the URL
  Future<String> uploadImageToStorage(String eventId, Uint8List file) async {
    // Compress the image before uploading
    Uint8List compressedFile = await _compressImage(file);

    // Then upload the compressed image
    return await StorageMethods()
        .uploadImageToStorage('event', compressedFile, true);
  }

  /// Method to create a new event in Firestore.
  Future<void> createEvent({
    required String eventName,
    required String description,
    required String location,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String groupSize,
    required XFile imageUrl,
    required int duration, // Duration in minutes
  }) async {
    try {
      String uid = _auth.getCurrentUserId()!; // Get current user UID
      String eventId = const Uuid().v1();
      Uint8List imageBytes = await imageUrl.readAsBytes();
      String eventUrl = await uploadImageToStorage(eventId, imageBytes);

      // await _firestore.collection('events').add({
      //   'uid': uid,
      //   'eventId': eventId,
      //   'event_name': eventName,
      //   'description': description,
      //   'location': location,
      //   'date': date.toIso8601String(), // Store date as string
      //   'start_time': startTime,
      //   'end_time': endTime,
      //   'group_size': groupSize,
      //   'image_url': eventUrl,
      //   'duration': duration,
      // });

// Create a map from the provided parameters
      Map<String, dynamic> data = {
        'uid': uid,
        'eventId': eventId,
        'event_name': eventName,
        'description': description,
        'location': location,
        'date': date.toIso8601String(), // Store date as string
        'start_time': startTime,
        'end_time': endTime,
        'group_size': groupSize,
        'image_url': eventUrl,
        'duration': duration,
      };

      // Save the report to Firestore
      await _firestore.collection('events').doc(eventId).set(data);
      print('Event created successfully');
    } catch (e) {
      print('Error creating event: $e');
      throw Exception('Failed to create event: $e');
    }
  }

  /// Method to retrieve all events from Firestore.
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();
      List<Map<String, dynamic>> eventsList = [];

      for (var doc in snapshot.docs) {
        eventsList.add({
          'id': doc.id, // Include the document ID
          ...doc.data() as Map<String, dynamic>,
        });
      }

      print('Retrieved ${eventsList.length} events');
      return eventsList;
    } catch (e) {
      print('Error retrieving events: $e');
      throw Exception('Failed to retrieve events: $e');
    }
  }

  /// Method to retrieve an event by its ID from Firestore.
  Future<Map<String, dynamic>?> getEventById(String eventId) async {
    try {
      DocumentSnapshot eventDoc =
          await _firestore.collection('events').doc(eventId).get();

      if (eventDoc.exists) {
        return eventDoc.data() as Map<String, dynamic>;
      } else {
        print('No event found for ID: $eventId');
        return null; // No event found for the given ID
      }
    } catch (e) {
      print('Error retrieving event by ID: $e');
      throw Exception('Failed to retrieve event by ID: $e');
    }
  }
}
