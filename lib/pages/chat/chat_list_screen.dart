import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting timestamps
import '../../widget/navbar/BottomNavBar.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String currentUserId;
  String? currentUserPhotoUrl; // To store the current user's profile picture
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> filteredChats = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    loadUserProfile(); // Load current user profile data (photoUrl)
    loadChats();
  }

  // Load current user data to get the profile picture
  Future<void> loadUserProfile() async {
    try {
      var userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      if (userDoc.exists) {
        setState(() {
          currentUserPhotoUrl = userDoc['photoUrl'];
        });
      }
    } catch (error) {
      print("Error loading user profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading user profile")),
      );
    }
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
        isLoading = false;
      });
    } catch (error) {
      print("Error loading chats: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading chats")),
      );
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
      String lastMessageTime = formatTimestamp(lastMessageData['timestamp']);

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

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat.Hm().format(dateTime); // Return only hour and minute
    } else {
      return DateFormat.yMMMd().add_jm().format(dateTime);
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
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: currentUserPhotoUrl != null
                  ? NetworkImage(currentUserPhotoUrl!)
                  : const AssetImage('assets/user/profile_pic.jpg')
                      as ImageProvider,
            ),
            const SizedBox(width: 10),
            const Text(
              'Chats',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredChats.isEmpty
                    ? const Center(child: Text("No chats available"))
                    : ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 24, // Adjust the size of the avatar
                              backgroundColor: Colors.grey[200],
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      'assets/user/profile_pic.jpg', // Local default image
                                  image: filteredChats[index]
                                      ['avatar'], // User avatar URL
                                  fit: BoxFit.cover,
                                  width:
                                      48, // Set the width to match avatar size
                                  height:
                                      48, // Set the height to match avatar size
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    // Display default image in case of an error
                                    return Image.asset(
                                      'assets/default_avatar.png',
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    );
                                  },
                                ),
                              ),
                            ),
                            title: Text(
                              filteredChats[index]['userName'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                  var lastMessageData =
                                      snapshot.data!.docs.first.data()
                                          as Map<String, dynamic>;
                                  String lastMessage = lastMessageData['text'];
                                  String lastMessageTime = formatTimestamp(
                                      lastMessageData['timestamp']);
                                  return Text(
                                    '$lastMessage • $lastMessageTime',
                                    style: const TextStyle(color: Colors.grey),
                                  );
                                } else {
                                  return const Text('No messages yet');
                                }
                              },
                            ),
                            trailing: const Icon(Icons.check_circle,
                                color: Colors.grey),
                            onTap: () {
                              BottomNavBar.visibility(false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailScreen(
                                    chatId: filteredChats[index]['chatId'],
                                    senderId: currentUserId,
                                    receiverId: filteredChats[index]
                                        ['receiverId'],
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
