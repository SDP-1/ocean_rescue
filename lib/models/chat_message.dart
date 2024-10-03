import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String id; // To hold Firestore document ID
  String text;
  String senderId;
  String receiverId;
  Timestamp timestamp; // Use Firestore Timestamp

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp, // Firestore will handle this properly
    };
  }

  // Factory method to create ChatMessage from Firestore data
  static ChatMessage fromFirestore(Map<String, dynamic> data, String id) {
    return ChatMessage(
      id: id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(), // Handle missing timestamps
    );
  }
}
