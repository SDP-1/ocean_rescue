import 'package:flutter/material.dart';

class EventInfoAlert extends StatelessWidget {
  final String alertText; // Add a field for the alert text

  const EventInfoAlert({
    super.key,
    required this.alertText, // Constructor to receive the alert text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                alertText,
                style: const TextStyle(color: Colors.blue, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
