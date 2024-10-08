enum NotificationType {
  post,
  event,
  message,
  reportDump,
  comment,
}

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String userId; // Changed from userProfileUrl to userId
  bool isRead;
  bool isForeground;

  // Use the enum for isFor attribute
  final NotificationType isFor; // Can be one of the defined enum values
  final String? postId; // Nullable to allow for different notification types
  final String? eventId; // Nullable to allow for different notification types
  final String?
      reportDumpId; // Nullable to allow for different notification types

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.userId, // Updated to userId
    this.isRead = false,
    this.isForeground = false,
    required this.isFor, // New parameter with enum type
    this.postId, // New parameter
    this.eventId, // New parameter
    this.reportDumpId, // New parameter
  });

  // Add the toJson method to convert the object to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp
          .toIso8601String(), // Convert DateTime to String for Firestore
      'userId': userId, // Include the new userId attribute
      'isRead': isRead,
      'isForeground': isForeground,
      'isFor': isFor.toString().split('.').last, // Convert enum to string
      'postId': postId, // Include the new attribute
      'eventId': eventId, // Include the new attribute
      'reportDumpId': reportDumpId, // Include the new attribute
    };
  }
}
