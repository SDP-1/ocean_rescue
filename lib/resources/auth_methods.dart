import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ocean_rescue/models/user.dart' as model;
import 'package:ocean_rescue/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

   // get user details using user ID
  Future<model.User?> getUserDetailsById(String userId) async {
    // String? userId = getUserId(); // Get the user ID

    if (userId != null) {
      try {
        // Fetch user details from Firestore using the user ID
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(userId).get();

        if (documentSnapshot.exists) {
          // Return user details from the document snapshot
          return model.User.fromSnap(documentSnapshot);
        }
      } catch (e) {
        print('Error fetching user details: $e');
        return null;
      }
    } else {
      print('No user is currently signed in.');
      return null;
    }
    return null;
  }

  // Load asset image as Uint8List
  Future<Uint8List> loadImageAsBytes(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  // Signing Up User
  Future<String> registation({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        // Registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Load image from assets and upload it
        Uint8List file = await loadImageAsBytes('assets/user/profile_pic.jpg');
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        print(photoUrl);

        // Create user model
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: '',
          followers: [],
          following: [],
        );

        // Adding user to our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        res = "The account already exists for that email.";
      } else if (e.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else {
        res = e.message ?? "Authentication error occurred";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String? getCurrentUserId() {
    User? currentUser = _auth.currentUser; // Get the current user
    return currentUser?.uid; // Return the user ID or null if not signed in
  }
  
}
