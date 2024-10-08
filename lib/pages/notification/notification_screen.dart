import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../../models/notification.dart'
    as CustomNotification; // Adjust the import as necessary
import '../../providers/notification_provider.dart'; // Import the NotificationProvider
import '../../widget/notification/notification_list.dart'; // Import the NotificationList widget

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key})
      : super(key: key); // Key changed to `Key?`

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the NotificationProvider instance via Provider
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Unread notifications tab
          NotificationList(
              notifications: notificationProvider.getUnreadNotifications()),
          // Read notifications tab
          NotificationList(
              notifications: notificationProvider.getReadNotifications()),
        ],
      ),
    );
  }
}
