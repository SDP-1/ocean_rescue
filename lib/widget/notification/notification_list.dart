import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification.dart' as CustomNotification;
import '../../providers/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for fetching user data

class NotificationList extends StatelessWidget {
  final List<CustomNotification.Notification> notifications;

  NotificationList({required this.notifications});

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
            _seekNotification(
                context, notification); // Correctly using context here
          },
          child: Dismissible(
            key: Key(notification.id),
            direction: DismissDirection
                .endToStart, // Slide to delete from right to left
            background: _buildDismissBackground(),
            onDismissed: (direction) {
              Provider.of<NotificationProvider>(context, listen: false)
                  .deleteNotification(notification.id);
            },
            child: FutureBuilder<String>(
              future: _fetchUserPhotoUrl(
                  notification.userId), // Fetch user photo URL
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildNotificationTile(notification, null, true);
                } else if (snapshot.hasError) {
                  return _buildNotificationTile(notification, null, false);
                } else {
                  return _buildNotificationTile(
                      notification, snapshot.data, false);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationTile(CustomNotification.Notification notification,
      String? photoUrl, bool isLoading) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: isLoading
            ? null
            : (photoUrl != null && photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : AssetImage('assets/images/default_user.png')
                    as ImageProvider), // Use a default image if URL fails
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
        // Provider.of<NotificationProvider>(context, listen: false)
        //     .markAsRead(notification.id);
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

  void _seekNotification(
      BuildContext context, CustomNotification.Notification notification) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: _fetchUserPhotoUrl(
                    notification.userId), // Fetch user photo URL
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                        child: CircularProgressIndicator());
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(notification.message),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .markAsRead(notification.id);
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: const Text('Mark as Read'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .deleteNotification(notification.id);
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
      return userDoc['photoUrl'] ??
          ''; // Return the photoUrl or an empty string if not available
    } catch (e) {
      print("Error fetching user photo URL: $e");
      return ''; // Return an empty string in case of error
    }
  }
}
