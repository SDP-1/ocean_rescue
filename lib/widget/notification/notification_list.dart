import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification.dart' as CustomNotification;
import '../../providers/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for fetching user data

class NotificationList extends StatelessWidget {
  final List<CustomNotification.Notification> notifications;

  NotificationList({required this.notifications, required void Function(CustomNotification.Notification notification) onNotificationTap});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No notifications yet!'),
      ); // Handle empty state
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return GestureDetector(
          onLongPress: () {
            _seekNotification(context, notification);
          },
          child: Dismissible(
            key: Key(notification.id),
            direction: DismissDirection.endToStart,
            background: _buildDismissBackground(),
            onDismissed: (direction) {
              _deleteNotification(context, notification.id);
            },
            child: FutureBuilder<String>(
              future: _fetchUserPhotoUrl(notification.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildNotificationTile(context, notification, null, true);
                } else if (snapshot.hasError) {
                  return _buildNotificationTile(context, notification, null, false);
                } else {
                  return _buildNotificationTile(context, notification, snapshot.data, false);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, CustomNotification.Notification notification,
      String? photoUrl, bool isLoading) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: isLoading
            ? null
            : (photoUrl != null && photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : AssetImage('assets/images/default_user.png')
                    as ImageProvider),
        child: isLoading ? CircularProgressIndicator() : null,
      ),
      title: Text(
        notification.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(notification.message),
      trailing: notification.isRead
          ? const Icon(Icons.check, color: Colors.green)
          : const Icon(Icons.new_releases, color: Colors.red),
      onTap: () {
        _markAsRead(context, notification); // Mark as read on tap
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _seekNotification(BuildContext context, CustomNotification.Notification notification) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: _fetchUserPhotoUrl(notification.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const CircleAvatar(backgroundColor: Colors.grey);
                  } else {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                      radius: 40.0,
                    );
                  }
                },
              ),
              const SizedBox(height: 16.0),
              Text(notification.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(notification.message),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _markAsRead(context, notification);
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: const Text('Mark as Read'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      _deleteNotification(context, notification.id);
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _fetchUserPhotoUrl(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc['photoUrl'] ?? ''; // Return the photoUrl or an empty string if not available
    } catch (e) {
      print("Error fetching user photo URL: $e");
      return ''; // Return an empty string in case of error
    }
  }

  void _markAsRead(BuildContext context, CustomNotification.Notification notification) {
    Provider.of<NotificationProvider>(context, listen: false)
        .markAsRead(notification.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${notification.title} marked as read')),
    );
  }

  void _deleteNotification(BuildContext context, String notificationId) {
    Provider.of<NotificationProvider>(context, listen: false)
        .deleteNotification(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification deleted')),
    );
  }
}
