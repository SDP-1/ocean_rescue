// lib/widgets/stat_column.dart

import 'package:flutter/material.dart';

class StatColumn extends StatelessWidget {
  final String label;
  final String count;

  const StatColumn({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
