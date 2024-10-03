import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['photoUrl']),
                ),
                title: Text(user['username']),
                onTap: () {
                  String chatId = user['uid'] + '_' + FirebaseAuth.instance.currentUser!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                        chatId: chatId,
                        senderId: FirebaseAuth.instance.currentUser!.uid,
                        receiverId: user['uid'],
                        name: user['username'],
                        avatar: user['photoUrl'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
