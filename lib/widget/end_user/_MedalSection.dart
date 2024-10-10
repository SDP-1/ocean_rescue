// lib/widgets/medal_section.dart

import 'package:flutter/material.dart';

class MedalSection extends StatelessWidget {
  const MedalSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/medals/bronze.png',
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 8),
          const Text(
            'Member',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
