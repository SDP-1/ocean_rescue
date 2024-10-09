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
  late TabController
      _tabController; // Use late initialization for TabController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Start listening for notifications when the screen is initialized
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider
        .startListeningForNotifications(); // Start real-time listener
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // This function handles marking the notification as read
  void _markNotificationAsRead(CustomNotification.Notification notification) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.markAsRead(
        notification.id); // Mark the notification as read in the provider
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
          notificationProvider.getUnreadNotifications().isEmpty
              ? const Center(child: Text("No unread notifications"))
              : NotificationList(
                  notifications: notificationProvider.getUnreadNotifications(),
                  onNotificationTap:
                      _markNotificationAsRead, // Pass the callback to mark as read
                ),

          // Read notifications tab
          notificationProvider.getReadNotifications().isEmpty
              ? const Center(child: Text("No read notifications"))
              : NotificationList(
                  notifications: notificationProvider.getReadNotifications(),
                  onNotificationTap: (notification) {
                    // Optionally, this can be a no-op or handle other actions if needed
                  }, // Required even for read notifications
                ),
        ],
      ),
    );
  }
}
