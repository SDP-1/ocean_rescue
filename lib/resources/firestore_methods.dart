import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ocean_rescue/models/post.dart';
import 'package:ocean_rescue/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user UID
  String getCurrentUserId() {
    return _auth.currentUser!.uid;
  }

  // Compress the image to ensure it's less than 2MB
  Future<Uint8List> _compressImage(Uint8List file) async {
    // Compress the image using flutter_image_compress
    Uint8List? compressedImage = await FlutterImageCompress.compressWithList(
      file,
      minWidth: 1080, // You can adjust width and height as needed
      minHeight: 1080,
      quality:
          85, // Quality can be adjusted between 0-100, reduce to lower size
    );

    if (compressedImage != null &&
        compressedImage.lengthInBytes < 2 * 1024 * 1024) {
      // If compressed image size is below 2MB, return it
      return compressedImage;
    } else {
      // If compression failed, return the original file
      return file;
    }
  }

  // Upload image and return the URL
  Future<String> uploadImageToStorage(String postId, Uint8List file) async {
    // Compress the image before uploading
    Uint8List compressedFile = await _compressImage(file);

    // Then upload the compressed image
    return await StorageMethods()
        .uploadImageToStorage('posts', compressedFile, true);
  }

  // Create a new post
  Future<String> createPost(
      String title, String description, Uint8List file) async {
    String res = "Some error occurred";
    try {
      String uid = getCurrentUserId(); // Get current user UID
      String postId = const Uuid().v1();
      String postUrl = await uploadImageToStorage(postId, file);

      Post post = Post(
        title: title,
        description: description,
        uid: uid, // Use current user UID here
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Like or unlike a post
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post a new comment
  Future<String> postComment(String postId, String text, String uid) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1(); // Generate a unique comment ID
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        return 'success';
      } else {
        return 'Comment cannot be empty';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Follow or unfollow a user
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  // Fetch comments with user data
  Future<List<Map<String, dynamic>>> fetchCommentsWithUserData(
      String postId) async {
    List<Map<String, dynamic>> commentsList = [];
    QuerySnapshot commentsSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();

    for (var doc in commentsSnapshot.docs) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(doc['uid']).get();

      commentsList.add({
        'commentId': doc.id,
        'text': doc['text'],
        'datePublished': doc['datePublished'],
        'uid': doc['uid'],
        'profilePic':
            userSnapshot['photoUrl'] ?? 'https://via.placeholder.com/150',
        'name': userSnapshot['username'] ?? 'Unknown',
      });
    }

    return commentsList;
  }
}
