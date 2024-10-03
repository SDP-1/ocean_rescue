import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/dumpReport/DumpReportHistory.dart';
import 'package:ocean_rescue/pages/notification/NotificationScreen.dart';
import 'package:ocean_rescue/pages/welcome/signin_screen.dart';
import 'package:ocean_rescue/widget/popup/delete_confirmation_popup.dart';

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
      //home: SignInScreen(),
      // home: BottomNavBar(),
      // home: SplashScreen(),
      home : DumpReportHistory(),
     //home : delete_confirmation_popup(),
    
    );
  }
}
