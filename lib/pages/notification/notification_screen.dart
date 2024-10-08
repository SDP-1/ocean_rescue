import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../../models/notification.dart' as CustomNotification;
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'Notification',
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
          _buildNotificationList(notificationProvider.getUnreadNotifications()),
          // Read notifications tab
          _buildNotificationList(notificationProvider.getReadNotifications()),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
      List<CustomNotification.Notification> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No notifications yet!'),
      ); // Handle empty state
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(notification.userProfileUrl),
          ),
          title: Text(
            notification.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(notification.message),
          trailing: notification.isRead
              ? null
              : const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 12,
                ),
        );
      },
    );
  }
}
