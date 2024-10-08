class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String userProfileUrl;
  bool isRead;
  bool isForeground;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.userProfileUrl,
    this.isRead = false,
    this.isForeground = false,
  });

  // Add the toJson method to convert the object to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'userProfileUrl': userProfileUrl,
      'isRead': isRead,
      'isForeground': isForeground,
    };
  }
}
