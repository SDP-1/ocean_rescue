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

  ReportDump({
    required this.rdid,
    required this.uid,
    required this.title,
    required this.description,
    required this.urgencyLevel,
    required this.eventLocation,
    required this.imageUrl,
    required this.timestamp,
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
    };
  }

  // Create a ReportDump object from a Map (Firestore document)
  factory ReportDump.fromJson(Map<String, dynamic> json) {
    return ReportDump(
      rdid: json['rdid'] as String,
       uid: json['uid'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      urgencyLevel: json['urgencyLevel'] as String,
      eventLocation: json['eventLocation'] as String,
      imageUrl: json['imageUrl'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
