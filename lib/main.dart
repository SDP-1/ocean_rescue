import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/welcome/signin_screen.dart'; // Ensure this path is correct
import 'package:ocean_rescue/providers/notification_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => NotificationProvider()), // Notification Provider
      ],
      child: MaterialApp(
        title: 'Ocean Rescue',
        debugShowCheckedModeBanner: false,
        home: const SignInScreen(),
      ),
    );
  }
}
