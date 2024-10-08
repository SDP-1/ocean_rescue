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

  List<CustomNotification.Notification> get notifications => _notifications;

  Future<void> _loadCurrentUser() async {
    firebase_auth.User? user = _auth.currentUser; // Use the prefixed import
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      _currentUser = User.fromSnap(userDoc);
      await _loadNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    if (_currentUser != null) {
      try {
        // Fetch notifications for the current user based on their notification IDs
        if (_currentUser!.notifications.isNotEmpty) {
          final snapshot = await _firestore
              .collection('notifications')
              .where(FieldPath.documentId,
                  whereIn:
                      _currentUser!.notifications) // Filter by notification IDs
              .get();

          _notifications = snapshot.docs.map((doc) {
            final data = doc.data();
            return CustomNotification.Notification(
              id: doc.id,
              title: data['title'],
              message: data['message'],
              timestamp: (data['timestamp'] as Timestamp).toDate(),
              userProfileUrl: data['userProfileUrl'],
              isRead: data['isRead'] ?? false,
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
        'userProfileUrl': notification.userProfileUrl,
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
        userProfileUrl: notification.userProfileUrl,
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

  List <CustomNotification.Notification> getUnreadNotifications() {
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
