import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ocean_rescue/models/post.dart';
import 'package:ocean_rescue/providers/notification_provider.dart';
import 'package:ocean_rescue/resources/notification_sender.dart';
import 'package:ocean_rescue/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/notification.dart';

class PostFireStoreMethods {
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

      // Send notifications to all users
      await sendNewPostNotificationToAllUsers(postId, title);

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Assuming this is part of your NotificationProvider class
  Future<void> sendNewPostNotificationToAllUsers(
      String postId, String postTitle) async {
    try {
      // Fetch all users
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      List<DocumentSnapshot> userDocs = usersSnapshot.docs;

      for (var userDoc in userDocs) {
        String userId = userDoc.id;

        // Create a unique notification ID
        String notificationId = const Uuid().v1();

        // Create the notification data
        Notification notification = Notification(
          id: notificationId,
          title: 'New Post Alert!',
          message: 'Check out the new post: $postTitle',
          timestamp: DateTime.now(),
          userId: getCurrentUserId(), // Use userId instead of userProfileUrl
          isRead: false,
          isForeground: false,
          isFor: NotificationType.post, // Set isFor attribute to 'post'
          postId: postId, // Add postId to the notification
        );

        // Add the notification to the notifications collection
        // await _firestore
        //     .collection('notifications')
        //     .doc(notificationId)
        //     .set(notification.toJson());

        // Add the notification ID to the user's notifications array
        // await _firestore.collection('users').doc(userId).update({
        //   'notifications': FieldValue.arrayUnion([notificationId]),
        // });

        // Call the addNotification method to add the notification
        // NotificationProvider notificationProvider = NotificationProvider();
        // await notificationProvider.addNotification(notification);

        // Add the notification to the notifications collection
        NotificationSender.addNotificationToDatabase(notification, userId);
      }
    } catch (err) {
      print("Failed to send notifications: $err");
    }
  }

// Like or unlike a post
  Future<String> likePost(String postId, String uid) async {
    String res = "Some error occurred";
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot postDoc = await transaction.get(postRef);
        if (!postDoc.exists) {
          throw Exception("Post does not exist!");
        }

        List<dynamic> likes = postDoc['likes'] ?? [];

        if (likes.contains(uid)) {
          // Unlike the post
          transaction.update(postRef, {
            'likes': FieldValue.arrayRemove([uid]),
          });
        } else {
          // Like the post
          transaction.update(postRef, {
            'likes': FieldValue.arrayUnion([uid]),
          });
        }
      });

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
        // 'profilePic':
        //     userSnapshot['photoUrl'] ?? 'https://via.placeholder.com/150',
        // 'name': userSnapshot['username'] ?? 'Unknown',
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

  Future<String> updatePost(
      String postId, String title, String description, Uint8List file) async {
    String res = "Some error occurred";
    try {
      // Upload new image to storage and get the new URL
      String postUrl = await uploadImageToStorage(postId, file);

      // Update the post with new data in Firestore
      await _firestore.collection('posts').doc(postId).update({
        'title': title,
        'description': description,
        'postUrl': postUrl, // Update post URL with the new image
        'datePublished': DateTime.now(), // Optionally update the published date
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatePostWithoutImage(
      String postId, String title, String description) async {
    String res = "Some error occurred";
    try {
      // Update the post's title and description without changing the image
      await _firestore.collection('posts').doc(postId).update({
        'title': title,
        'description': description,
        'datePublished': DateTime.now(), // Optionally update the published date
      });

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
