import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../resources/auth_methods.dart';
import '../models/user.dart';

class ProfileFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to update username, bio, and profile picture for a user
  Future<String> updateUsernameBioAndPhoto({
    required String username,
    required String bio,
    String? photoUrl, // Optional parameter for profile picture URL
  }) async {
    String res = "Some error occurred";
    try {
      // Get the current user's UID
      String uid = _auth.currentUser!.uid;

      // Create a reference to the user document in the 'users' collection
      DocumentReference userDocRef = _firestore.collection('users').doc(uid);

      // Prepare the update map
      Map<String, dynamic> updateData = {
        'username': username,
        'bio': bio,
      };

      // If a photo URL is provided, include it in the update
      if (photoUrl != null && photoUrl.isNotEmpty) {
        updateData['photoUrl'] = photoUrl;
      }

      // Update the Firestore document with the new data
      await userDocRef.update(updateData);

      res = "Profile updated successfully";
    } on FirebaseException catch (e) {
      res = e.message ?? "Error updating profile";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }



  // Method to retrieve the email using the user's UID
  Future<String> getEmailByUid(String uid) async {
    String res = "Some error occurred";
    try {
      // Reference to the specific user's document in the 'uers' collection
      DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();

      // Check if the document exists and retrieve the email field
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        String email = data['email'] ?? 'No email found'; // Get email or provide a default message
        res = email;
      } else {
        res = "User not found";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // Method to get user details (username and bio) by UID
// Method to get user details (username, bio, and photoUrl) by UID
Future<Map<String, dynamic>> getUserDetailsByUid(String uid) async {
    Map<String, dynamic> userDetails = {
        'username': 'No username found',
        'bio': 'No bio found',
        'photoUrl': 'No photo found', // Default message for photoUrl
    };

    try {
        // Reference to the user's document in the 'users' collection
        DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();

        // Check if the document exists and retrieve the username, bio, and photoUrl fields
        if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
            userDetails['username'] = data['username'] ?? userDetails['username']; // Get username or provide a default message
            userDetails['bio'] = data['bio'] ?? userDetails['bio']; // Get bio or provide a default message
            userDetails['photoUrl'] = data['photoUrl'] ?? userDetails['photoUrl']; // Get photoUrl or provide a default message
        } else {
            userDetails['username'] = "User not found";
            userDetails['bio'] = "User not found";
        }
    } catch (e) {
        userDetails['username'] = e.toString();
        userDetails['bio'] = e.toString();
        userDetails['photoUrl'] = e.toString(); // Set error message for photoUrl
    }

    return userDetails;
}


}
