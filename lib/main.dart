import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocen rescue',
      debugShowCheckedModeBanner: false,
      home:BottomNavBar(),
    );
  }
}



