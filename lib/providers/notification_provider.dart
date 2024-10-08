import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ocean_rescue/resources/notification_sender.dart';
import '../models/notification.dart' as CustomNotification;
import '../models/user.dart';

class NotificationProvider with ChangeNotifier {
  List<CustomNotification.Notification> _notifications = [];
  Set<String> _previousNotificationIds =
      {}; // To store the previous notification IDs
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  User? _currentUser;

  // Initialize local notifications
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    _loadCurrentUser();
    _initializeLocalNotifications();
  }

  // Initialize local notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Getter to expose notifications list
  List<CustomNotification.Notification> get notifications => _notifications;

  // Load current user and start listening for notifications
  Future<void> _loadCurrentUser() async {
    firebase_auth.User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      _currentUser = User.fromSnap(userDoc);
      startListeningForNotifications(); // Start real-time listener
    }
  }

  // Start listening for real-time notification updates
  void startListeningForNotifications() {
    if (_currentUser != null) {
      // Listen to changes in the user's document to get updated notifications array
      _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .snapshots()
          .listen((userSnapshot) async {
        if (userSnapshot.exists) {
          // Get the list of notification IDs from the user's document
          List<dynamic> notificationIds =
              userSnapshot.data()?['notifications'] ?? [];

          // If there are no notifications, reset the _notifications list
          if (notificationIds.isEmpty) {
            _notifications = [];
            notifyListeners();
            return;
          }

          // Fetch all notifications with the matching IDs from the 'notifications' collection
          QuerySnapshot notificationsSnapshot = await _firestore
              .collection('notifications')
              .where(FieldPath.documentId, whereIn: notificationIds)
              .get();

          // Convert the notification documents to your custom Notification model
          List<CustomNotification.Notification> fetchedNotifications =
              notificationsSnapshot.docs.map((doc) {
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
              eventId: data['eventId'],
              reportDumpId: data['reportDumpId'],
            );
          }).toList();

          // Detect newly added notifications
          Set<String> currentNotificationIds =
              fetchedNotifications.map((notif) => notif.id).toSet();
          Set<String> newNotificationIds =
              currentNotificationIds.difference(_previousNotificationIds);

          // Show local notifications for newly added notifications
          for (var notification in fetchedNotifications) {
            if (newNotificationIds.contains(notification.id)) {
              NotificationSender.showLocalNotification(
                  notification); // Call the static method to show notification
            }
          }

          // Update the _notifications list and the previous notification IDs set
          _notifications = fetchedNotifications;
          _previousNotificationIds = currentNotificationIds;

          // Notify the UI that the notifications list has been updated
          notifyListeners();
        }
      });
    }
  }

  // Function to delete a notification
  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).delete();
      _notifications.removeWhere((notification) => notification.id == id);

      if (_currentUser != null) {
        _currentUser!.notifications.remove(id);
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'notifications': FieldValue.arrayRemove([id]),
        });
      }

      notifyListeners(); // Update UI
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  // Mark a notification as read
  void markAsRead(String id) {
    final index =
        _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _firestore.collection('notifications').doc(id).update({'isRead': true});
      notifyListeners(); // Notify UI that notification was read
    }
  }

  // Get unread notifications
  List<CustomNotification.Notification> getUnreadNotifications() {
    return _notifications.where((notif) => !notif.isRead).toList();
  }

  // Get read notifications
  List<CustomNotification.Notification> getReadNotifications() {
    return _notifications.where((notif) => notif.isRead).toList();
  }

  // Get today's notifications
  List<CustomNotification.Notification> getTodayNotifications() {
    DateTime today = DateTime.now();
    return _notifications
        .where((notif) => isSameDate(notif.timestamp, today))
        .toList();
  }

  // Get new notifications (within the last 24 hours)
  List<CustomNotification.Notification> getNewNotifications() {
    DateTime now = DateTime.now();
    return _notifications
        .where(
            (notif) => notif.timestamp.isAfter(now.subtract(Duration(days: 1))))
        .toList();
  }

  // Get older notifications (older than 24 hours)
  List<CustomNotification.Notification> getOlderNotifications() {
    DateTime now = DateTime.now();
    return _notifications
        .where((notif) =>
            notif.timestamp.isBefore(now.subtract(Duration(days: 1))))
        .toList();
  }

  // Helper function to check if two dates are the same
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
