import 'package:flutter/material.dart';

class CreateEvent extends StatelessWidget {
  const CreateEvent({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Center(
        child: Text('Create Event Screen'),
      ),
    );
  }
}