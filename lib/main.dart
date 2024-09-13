import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/welcome/signup_screen.dart';

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
    return MaterialApp(
      title: 'Ocean Rescue', // Fixed the typo in the app title
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
