import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart' as CustomNotification;
import '../models/user.dart';

class NotificationSender {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Local notification initialization (this can't be static as it involves instance level config)
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Constructor to initialize local notifications, called when the class is instantiated
  NotificationSender() {
    _initializeLocalNotifications();
  }

  // Static method to initialize local notifications
  static void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Static function to add a new notification to Firestore and user's notifications array
  static Future<void> addNotificationToDatabase(
      CustomNotification.Notification notification, String userId) async {
    try {
      // Add the notification to the notifications collection
      await _firestore
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toJson());

      // Add the notification ID to the user's notifications array
      await _firestore.collection('users').doc(userId).update({
        'notifications': FieldValue.arrayUnion([notification.id]),
      });

      // Show a local notification (you cannot directly call an instance method from a static method)
      await _showLocalNotification(notification);
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  // Static function to show local notification
  static Future<void> _showLocalNotification(
      CustomNotification.Notification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0,
      notification.title,
      notification.message,
      platformChannelSpecifics,
      payload: 'Default_Sound', // You can add additional data here
    );
  }
}
