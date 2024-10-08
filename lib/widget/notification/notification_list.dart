import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification.dart' as CustomNotification; 
import '../../providers/notification_provider.dart'; 

class NotificationList extends StatelessWidget {
  final List<CustomNotification.Notification> notifications;

  NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
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
            direction: DismissDirection.endToStart, // Slide to delete from right to left
            background: _buildDismissBackground(),
            onDismissed: (direction) {
              Provider.of<NotificationProvider>(context, listen: false)
                  .deleteNotification(notification.id);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(notification.userProfileUrl),
              ),
              title: Text(notification.title),
              subtitle: Text(notification.message),
              trailing: notification.isRead
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.new_releases, color: Colors.red),
              onTap: () {
                Provider.of<NotificationProvider>(context, listen: false)
                    .markAsRead(notification.id);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      alignment: Alignment.centerRight,
      child: Container(
                width: 80.0, // Width of the delete button
        color: Colors.red,
        child: Center(
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
    );
  }

  void _seekNotification(BuildContext context, CustomNotification.Notification notification) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(notification.userProfileUrl),
                radius: 40.0,
              ),
              SizedBox(height: 16.0),
              Text(notification.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(notification.message),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .markAsRead(notification.id);
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: Text('Mark as Read'),
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
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

