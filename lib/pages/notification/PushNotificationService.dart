// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:ocean_rescue/models/notification.dart';

// void _showLocalNotification(Notification notification) async {
//     // Download the user profile image
//     // final Uint8Lis? largeIcon =
//     //     await _getByteArrayFromUrl(notification.userProfileUrl);

//     // Configure the notification details
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id', // Replace with your channel ID
//       'your_channel_name', // Replace with your channel name
//       importance: Importance.max,
//       priority: Priority.high,
//       //if u wanna show the privew of the poste image you can use this to it
//       // styleInformation: largeIcon != null
//       //     ? BigPictureStyleInformation(
//       //         ByteArrayAndroidBitmap(largeIcon),
//       //         largeIcon: ByteArrayAndroidBitmap(largeIcon),
//       //         contentTitle: notification.title,
//       //         summaryText: notification.message,
//       //         hideExpandedLargeIcon: false,
//       //       )
//       //     : null,

//       largeIcon: largeIcon != null ? ByteArrayAndroidBitmap(largeIcon): null,
//     );

//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID, can be used to update/remove the notification
//       notification.title,
//       notification.message,
//       platformChannelSpecifics,
//       payload:
//           'Default_Sound', // Payload can be used to handle notification tap
//     );
//   }

// class PushNotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


//   Future<void> initialize() async {
//     // Request permissions for iOS
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     // Handle messages when the app is in the background or terminated
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Display the push notification
//       _showNotification(message);
//     });
//   }

//   // Method to display local notifications when receiving push notification
//   Future<void> _showNotification(RemoteMessage message) async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//     );

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('ic_launcher'); // Replace with your launcher icon

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     flutterLocalNotificationsPlugin.show(
//       message.notification.hashCode,
//       message.notification?.title,
//       message.notification?.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           icon: 'ic_launcher', // Replace with your app's icon
//         ),
//       ),
//     );
//   }
// }
