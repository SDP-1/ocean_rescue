import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:ocean_rescue/pages/welcome/signin_screen.dart'; // Import SignIn screen
import 'package:ocean_rescue/pages/welcome/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:ocean_rescue/providers/notification_provider.dart';

import 'widget/navbar/BottomNavBar.dart'; // Notification Provider

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
    print('FIREBASE ERROR: $e');
  }

  // Set up the background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => NotificationProvider()), // Register NotificationProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocean Rescue',
      debugShowCheckedModeBanner: false,
      home: AuthChecker(), // Set the initial screen based on auth state
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for auth state, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // If logged in, navigate to HomePage
          return const SplashScreen(); // Replace with the screen you want after login
        } else {
          // If not logged in, show SignInScreen
          return const SignInScreen();
        }
      },
    );
  }
}
