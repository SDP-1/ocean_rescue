import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/Achievements/achievements_page.dart';
import 'package:ocean_rescue/pages/dumpReport/DumpReportHistory.dart';
import 'package:ocean_rescue/pages/dumpReport/dump_description_edit.dart';
import 'package:ocean_rescue/pages/event/create_event_screen1.dart';
import 'package:ocean_rescue/pages/event/event_details_screen.dart';
import 'package:ocean_rescue/pages/post/create_post_screen.dart';
import 'package:ocean_rescue/pages/profile/edit_profile.dart';
import 'package:ocean_rescue/pages/profile/edit_profile_screen.dart';
import 'package:ocean_rescue/pages/welcome/signin_screen.dart';
import 'package:ocean_rescue/widget/event/EventDetailsCard.dart';
import 'package:ocean_rescue/widget/popup/delete_confirmation_popup.dart';
import 'package:ocean_rescue/pages/welcome/signin_screen.dart'; // Ensure this path is correct
import 'package:ocean_rescue/providers/notification_provider.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('FIREBASE ERROR : $e');
  }

  // Set up the background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                NotificationProvider()), // Register NotificationProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ocean Rescue',
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
      //home : EditProfile(),
      // home: BottomAppBar(),
      // home: SplashScreen(),
      // home : DumpReportHistory(),
      //home : delete_confirmation_popup(),
      //home : DumpDetailsScreen(),
      // home: EventDetailsScreen(),
      // home: CreateEventScreen1(),
      // home: CreatePostScreen(),
      // home: EditProfile(),
    );
  }
}
