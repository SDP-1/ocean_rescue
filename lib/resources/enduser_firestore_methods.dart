// lib/resources/firebase_methods.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:ocean_rescue/models/user.dart';

class EnduserFirestoreMethods {
  // Fetch user details from Firestore
  Future<User> fetchUserDetails() async {
    final currentUser = auth.FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    return User.fromSnap(doc);
  }

  // Create a stream to listen for the following status
  Stream<bool> getFollowingStream(String currentUserId, String targetUserId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((doc) {
      User currentUser = User.fromSnap(doc);
      return currentUser.following.contains(targetUserId);
    });
  }

  // Follow or unfollow the user based on current state
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
    DocumentReference targetUserRef = FirebaseFirestore.instance.collection('users').doc(targetUserId);

    DocumentSnapshot currentUserDoc = await currentUserRef.get();
    User currentUser = User.fromSnap(currentUserDoc);

    if (currentUser.following.contains(targetUserId)) {
      await currentUserRef.update({
        'following': FieldValue.arrayRemove([targetUserId])
      });
      await targetUserRef.update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });
    } else {
      await currentUserRef.update({
        'following': FieldValue.arrayUnion([targetUserId])
      });
      await targetUserRef.update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });
    }
  }
}
