import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../resources/auth_methods.dart';
import '../models/user.dart';

class ProfileFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to update username and bio for a user
  Future<String> updateUsernameAndBio({
    required String username,
    required String bio,
  }) async {
    String res = "Some error occurred";
    try {
      // Get the current user's UID
      String uid = _auth.currentUser!.uid;

      // Create a reference to the user document in the 'uers' collection
      DocumentReference userDocRef = _firestore.collection('uers').doc(uid);

      // Update the username and bio fields in Firestore
      await userDocRef.update({
        'username': username,
        'bio': bio,
      });

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

}
