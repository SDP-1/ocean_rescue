// lib/widgets/stat_column.dart

import 'package:flutter/material.dart';

class StatColumn extends StatelessWidget {
  final String label;
  final String count;

  const StatColumn({Key? key, required this.label, required this.count}) : super(key: key);

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
