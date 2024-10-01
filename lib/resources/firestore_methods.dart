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
    // Check if the image is larger than 1MB
    if (file.lengthInBytes <= .5 * 1024 * 1024) {
      // If the image is already below .5MB, return the original image
      return file;
    }

    // Compress the image using flutter_image_compress if it's larger than .5MB
    Uint8List? compressedImage = await FlutterImageCompress.compressWithList(
      file,
      minWidth: 1080, // Adjust width and height as needed
      minHeight: 1080,
      quality: 80, // Adjust quality, lower quality for smaller size
    );

    if (compressedImage != null &&
        compressedImage.lengthInBytes <= 1 * 1024 * 1024) {
      return compressedImage;
    }
    // If compression doesn't reduce the size enough, return the original image
    return file;
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
  Future<String> likePost(String postId, String uid) async {
    String res = "Some error occurred";
    try {
      // Get the current likes array from Firestore
      DocumentSnapshot postDoc =
          await _firestore.collection('posts').doc(postId).get();
      List<dynamic> currentLikes =
          postDoc['likes'] ?? []; // Retrieve current likes or an empty list

      if (currentLikes.contains(uid)) {
        // Remove the like
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove(
              [uid]), // Correctly remove the user's ID from likes
        });
      } else {
        // Add the like
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion(
              [uid]), // Correctly add the user's ID to likes
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Bookmark a post
  Future<String> bookmarkPost(String postId) async {
    String res = "Some error occurred";
    try {
      String uid = getCurrentUserId(); // Get current user UID
      await _firestore.collection('users').doc(uid).update({
        'bookmarks': FieldValue.arrayUnion([postId]),
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Remove bookmark from a post
  Future<String> removeBookmark(String postId) async {
    String res = "Some error occurred";
    try {
      String uid = getCurrentUserId(); // Get current user UID
      await _firestore.collection('users').doc(uid).update({
        'bookmarks': FieldValue.arrayRemove([postId]),
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Fetch user bookmarks
  Future<List<String>> fetchUserBookmarks() async {
    String uid = getCurrentUserId();
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    return List<String>.from(snap['bookmarks'] ?? []);
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

  // Fetch posts with pagination
  Future<List<Post>> fetchPosts(
      {int limit = 10, DocumentSnapshot? lastDocument}) async {
    Query query = _firestore
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot querySnapshot = await query.get();
    List<Post> posts = querySnapshot.docs.map((doc) {
      return Post.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return posts;
  }

  // Fetch user data
  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }
}
