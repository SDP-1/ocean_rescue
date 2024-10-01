import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart'; // Import your BottomNavBar

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to BottomNavBar after 3 seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const BottomNavBar(), // Navigate to BottomNavBar
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image (Ocean water)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/welcome/splashScreen.png'), // Your ocean background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center image and text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Replace Icon with Image
                Image.asset(
                  'assets/logo/logo_without_name.png', // Your arrow image path
                  height: 60.0, // Adjust size according to your needs
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Ocean Rescue',
                  style: TextStyle(
                    fontSize: 24.0, // Adjust text size
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold, // Font weight
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
