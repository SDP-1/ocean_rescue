import 'package:flutter/material.dart';

import 'chat_detail_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatListScreen(),
    );
  }
}

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/user/profile_pic.jpg'), // Replace with the user avatar path
            ),
            SizedBox(width: 10),
            Text(
              'Chats',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage(chats[index]['avatar']!), // User avatar
                  ),
                  title: Text(
                    chats[index]['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${chats[index]['message']} • ${chats[index]['time']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(Icons.check_circle, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          name: chats[index]['name']!,
                          avatar: chats[index]['avatar']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> chats = [
  {
    'name': 'Martin Randolph',
    'message': "You: What's man!",
    'time': '9:40 AM',
    'avatar': 'assets/user/user1.jpg',
  },
  {
    'name': 'Andrew Parker',
    'message': 'You: Ok, thanks!',
    'time': '9:25 AM',
    'avatar': 'assets/user/user2.jpg',
  },
  {
    'name': 'Karen Castillo',
    'message': 'You: Ok, See you in To...',
    'time': 'Fri',
    'avatar': 'assets/user/user3.jpg',
  },
  {
    'name': 'Maisy Humphrey',
    'message': 'Have a good day, Maisy!',
    'time': 'Fri',
    'avatar': 'assets/user/user1.jpg',
  },
  {
    'name': 'Joshua Lawrence',
    'message': 'The business plan loo...',
    'time': 'Thu',
    'avatar': 'assets/user/user2.jpg',
  },
];
