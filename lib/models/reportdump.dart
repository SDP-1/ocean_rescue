import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ReportDump {
  final String id; // Unique identifier for the dump report
  final String name;
  final String description;
  final String urgencyLevel;
  final String eventLocation;
  final String imageUrl;
  final DateTime timestamp;

  ReportDump({
    required this.id,
    required this.name,
    required this.description,
    required this.urgencyLevel,
    required this.eventLocation,
    required this.imageUrl,
    required this.timestamp,
  });

  // Convert a ReportDump object into a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'urgencyLevel': urgencyLevel,
      'eventLocation': eventLocation,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }

  // Create a ReportDump object from a Map (Firestore document)
  factory ReportDump.fromJson(Map<String, dynamic> json) {
    return ReportDump(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      urgencyLevel: json['urgencyLevel'] as String,
      eventLocation: json['eventLocation'] as String,
      imageUrl: json['imageUrl'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
