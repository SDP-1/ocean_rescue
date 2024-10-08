import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase_auth; // Import with prefix
import '../models/notification.dart'
    as CustomNotification; // Alias for your Notification class
import '../models/user.dart'; // Import your User model

class NotificationProvider with ChangeNotifier {
  List<CustomNotification.Notification> _notifications = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance; // Use the prefixed import
  User? _currentUser;

  NotificationProvider() {
    _loadCurrentUser();
  }

  // Method to listen for changes in the notifications collection
  void startListeningForNotifications() {
    if (_currentUser != null) {
      _firestore
          .collection('notifications')
          .where('userId', isEqualTo: _currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        _loadNotifications();
      });
    }
  }

  List<CustomNotification.Notification> get notifications => _notifications;

  Future<void> _loadCurrentUser() async {
    firebase_auth.User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      _currentUser = User.fromSnap(userDoc);
      await _loadNotifications();
      startListeningForNotifications(); // Start listening for notifications
    }
  }

  Future<void> _loadNotifications() async {
    if (_currentUser != null) {
      try {
        if (_currentUser!.notifications.isNotEmpty) {
          final snapshot = await _firestore
              .collection('notifications')
              .where(FieldPath.documentId, whereIn: _currentUser!.notifications)
              .get();

          _notifications = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CustomNotification.Notification(
              id: doc.id,
              title: data['title'],
              message: data['message'],
              timestamp: DateTime.parse(data['timestamp']),
              userId: data['userId'],
              isRead: data['isRead'] ?? false,
              isForeground: data['isForeground'] ?? false,
              isFor: CustomNotification.NotificationType.values.firstWhere(
                (type) => type.toString().split('.').last == data['isFor'],
                orElse: () => CustomNotification.NotificationType.post,
              ),
              postId: data['postId'],
            );
          }).toList();
          notifyListeners();
        }
      } catch (e) {
        print("Error loading notifications: $e");
      }
    }
  }

  Future<void> addNotification(
      CustomNotification.Notification notification) async {
    try {
      final docRef = await _firestore.collection('notifications').add({
        'title': notification.title,
        'message': notification.message,
        'timestamp': notification.timestamp,
        'isRead': notification.isRead,
        'userId': notification.userId, // Use userId instead of userProfileUrl
        'isFor':
            notification.isFor.toString().split('.').last, // Store as string
        'postId': notification.postId, // New attribute
        'eventId': notification.eventId, // New attribute
        'reportDumpId': notification.reportDumpId, // New attribute
      });

      if (_currentUser != null) {
        // Add the new notification ID to the current user's notifications
        _currentUser!.addNotification(docRef.id);
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'notifications': FieldValue.arrayUnion(
              [docRef.id]), // Update user's notifications array in Firestore
        });
      }

      _notifications.add(CustomNotification.Notification(
        id: docRef.id,
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        userId: notification.userId, // Use userId instead of userProfileUrl
        isRead: notification.isRead,
        isForeground: notification.isForeground,
        isFor: notification.isFor,
        postId: notification.postId,
        eventId: notification.eventId,
        reportDumpId: notification.reportDumpId,
      ));
      notifyListeners();
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).delete();
      _notifications.removeWhere((notification) => notification.id == id);

      if (_currentUser != null) {
        // Remove the notification ID from the current user's notifications
        _currentUser!.notifications.remove(id);
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'notifications': FieldValue.arrayRemove(
              [id]), // Update user's notifications array in Firestore
        });
      }

      notifyListeners();
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  void markAsRead(String id) {
    final index =
        _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  List<CustomNotification.Notification> getUnreadNotifications() {
    return _notifications.where((notif) => !notif.isRead).toList();
  }

  List<CustomNotification.Notification> getReadNotifications() {
    return _notifications.where((notif) => notif.isRead).toList();
  }

  List<CustomNotification.Notification> getNewNotifications() {
    DateTime today = DateTime.now();
    return _notifications
        .where((notif) =>
            notif.timestamp.isAfter(today.subtract(Duration(days: 1))))
        .toList();
  }

  List<CustomNotification.Notification> getOlderNotifications() {
    DateTime today = DateTime.now();
    return _notifications
        .where((notif) =>
            notif.timestamp.isBefore(today.subtract(Duration(days: 1))))
        .toList();
  }

  List<CustomNotification.Notification> getTodayNotifications() {
    DateTime today = DateTime.now();
    return _notifications
        .where((notif) => isSameDate(notif.timestamp, today))
        .toList();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
