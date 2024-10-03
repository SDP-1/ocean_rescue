import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  List<String> chats; // New property to hold chat IDs

  User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    this.chats =
        const [], // Add chats as a named parameter with a default value
  });

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
      chats: List<String>.from(
          snapshot["chats"] ?? []), // Initialize with chats from Firestore
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "chats": chats, // Include chats when saving to Firestore
      };

  // Add a method to add a chat ID to the user's chats list
  void addChat(String chatId) {
    if (!chats.contains(chatId)) {
      chats.add(chatId);
    }
  }
}
