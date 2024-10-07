import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../widget/navbar/BottomNavBar.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> filteredChats = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      final chatSnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .get();

      List<Map<String, dynamic>> fetchedChats = [];
      for (var chatDoc in chatSnapshot.docs) {
        var chatData = await getChatData(chatDoc.id);
        if (chatData != null) {
          fetchedChats.add(chatData);
        }
      }

      setState(() {
        chats = fetchedChats;
        filteredChats = chats;
      });
    } catch (error) {
      print("Error loading chats: $error");
    }
  }

  Future<Map<String, dynamic>?> getChatData(String chatId) async {
    try {
      List<String> ids = chatId.split('_');
      if (ids.length != 2) return null;

      String receiverId = ids[0] == currentUserId ? ids[1] : ids[0];

      var messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isEmpty) return null;

      var lastMessageData = messagesSnapshot.docs.first.data();
      String lastMessage = lastMessageData['text'];
      String lastMessageTime = formatTimestamp(
          lastMessageData['timestamp']); // Use the formatting function

      var receiverData =
          await _firestore.collection('users').doc(receiverId).get();

      if (!receiverData.exists) return null;

      String userName = receiverData['username'];
      String userAvatar = receiverData['photoUrl'];

      return {
        'userName': userName,
        'message': lastMessage,
        'time': lastMessageTime,
        'avatar': userAvatar,
        'chatId': chatId,
        'receiverId': receiverId,
      };
    } catch (error) {
      print("Error fetching chat data: $error");
      return null;
    }
  }

  // Function to format the timestamp
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    // Check if the date is today
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat.Hm().format(dateTime); // Return only hour and minute
    } else {
      // Return formatted date and time
      return DateFormat.yMMMd()
          .add_jm()
          .format(dateTime); // Returns "Sep 14, 2024, 2:30 PM"
    }
  }

  // Method to handle search logic
  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredChats = chats
          .where((chat) =>
              chat['userName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/user/profile_pic.jpg'),
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
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(
            child: filteredChats.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(filteredChats[index]['avatar']),
                        ),
                        title: Text(
                          filteredChats[index]['userName']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('chats')
                              .doc(filteredChats[index]['chatId'])
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }
                            if (snapshot.hasError) {
                              return const Text('Error loading messages');
                            }
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              var lastMessageData = snapshot.data!.docs.first
                                  .data() as Map<String, dynamic>;
                              String lastMessage = lastMessageData['text'];
                              String lastMessageTime = formatTimestamp(
                                  lastMessageData[
                                      'timestamp']); // Use the formatting function
                              return Text(
                                '$lastMessage • $lastMessageTime',
                                style: const TextStyle(color: Colors.grey),
                              );
                            } else {
                              return const Text('No messages yet');
                            }
                          },
                        ),
                        trailing:
                            const Icon(Icons.check_circle, color: Colors.grey),
                        onTap: () {
                          BottomNavBar.visibility(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                chatId: filteredChats[index]['chatId'],
                                senderId: currentUserId,
                                receiverId: filteredChats[index]['receiverId'],
                                name: filteredChats[index]['userName'],
                                avatar: filteredChats[index]['avatar'],
                              ),
                            ),
                          ).then((_) {
                            BottomNavBar.visibility(true);
                          });
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
