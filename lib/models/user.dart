import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  int exp;
  List<String> chats; // Property to hold chat IDs
  List<String> notifications; // Property to hold notification IDs

  User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    this.exp = 0,
    this.chats = const [],
    this.notifications = const [],
  });

  // Factory method to create User from Firestore snapshot
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      exp: snapshot["exp"],
      chats: List<String>.from(snapshot["chats"] ?? []), // Initialize chats
      notifications: List<String>.from(
          snapshot["notifications"] ?? []), // Initialize notifications
    );
  }

  // Convert User to JSON format for Firestore
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "chats": chats,
        "notifications": notifications,
        "exp": exp, // Include notifications in Firestore
      };

  // Add a chat ID to the user's chats list
  void addChat(String chatId) {
    if (!chats.contains(chatId)) {
      chats.add(chatId);
    }
  }

  // Add a notification ID to the user's notifications list
  void addNotification(String notificationId) {
    if (!notifications.contains(notificationId)) {
      notifications.add(notificationId);
    }
  }
}
