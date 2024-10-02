import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Unread notifications tab
          _buildNotificationList(isUnread: true),
          // Read notifications tab
          _buildNotificationList(isUnread: false),
        ],
      ),
    );
  }

  Widget _buildNotificationList({required bool isUnread}) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'New Features',
        'description': 'Check out the new features in our app.',
        'image': 'assets/profile.png',
      },
      {
        'title': 'New Features',
        'description': 'Check out the new features in our app.',
        'image': 'assets/profile.png',
      },
      {
        'title': 'New Features',
        'description': 'Check out the new features in our app.',
        'image': 'assets/profile.png',
      },
      {
        'title': 'New Features',
        'description': 'Check out the new features in our app.',
        'image': 'assets/profile.png',
      },
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(notifications[index]['image']!),
          ),
          title: Text(
            notifications[index]['title']!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(notifications[index]['description']!),
          trailing: isUnread
              ? Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 12,
                )
              : null,
        );
      },
    );
  }
}
