import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class Post {
  final String title;
  final String description;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final List<String> likes; // Changed to List<String> for type safety

  Post({
    required this.title,
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    List<String>? likes, // Allow nullable input for likes
  }) : likes = likes ?? []; // Ensure likes is never null

  // Convert a Post object into a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'uid': uid,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'likes': likes,
    };
  }

  // Create a Post object from a Map (Firestore document)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] as String,
      description: json['description'] as String,
      uid: json['uid'] as String,
      postId: json['postId'] as String,
      datePublished: (json['datePublished'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      postUrl: json['postUrl'] as String,
      likes: List<String>.from(json['likes'] ?? []), // Ensure likes is a list of strings
    );
  }
}
