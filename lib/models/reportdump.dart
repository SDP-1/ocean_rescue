import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ReportDump {
  final String rdid;
  final String uid;
  final String title;
  final String description;
  final String urgencyLevel;
  final String eventLocation;
  final String imageUrl;
  final DateTime timestamp;
  final bool isReported; // Add the isReported field

  ReportDump({
    required this.rdid,
    required this.uid,
    required this.title,
    required this.description,
    required this.urgencyLevel,
    required this.eventLocation,
    required this.imageUrl,
    required this.timestamp,
    required this.isReported, // Include isReported in the constructor
  });

  // Convert a ReportDump object into a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'rdid': rdid,
      'uid': uid,
      'title': title,
      'description': description,
      'urgencyLevel': urgencyLevel,
      'eventLocation': eventLocation,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'isReported': isReported, // Add isReported to the JSON map
    };
  }

  // Create a ReportDump object from a Map (Firestore document)
  factory ReportDump.fromJson(Map<String, dynamic> json) {
    return ReportDump(
      rdid: json['rdid'] as String? ?? '', // Provide a default value
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      urgencyLevel: json['urgencyLevel'] as String? ?? '',
      eventLocation: json['eventLocation'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      isReported: json['isReported'] as bool? ?? false, // Default to false if not provided
    );
  }

  static ReportDump fromMap(Map<String, dynamic> data) {
    return ReportDump(
      rdid: data['rdid'] as String? ?? '',
      uid: data['uid'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      urgencyLevel: data['urgencyLevel'] as String? ?? '',
      eventLocation: data['eventLocation'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isReported: data['isReported'] as bool? ?? false,
    );
  }
}
