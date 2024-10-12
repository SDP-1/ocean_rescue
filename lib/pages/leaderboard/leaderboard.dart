import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../chat/chat_list_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/view_profile.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: _isSearching
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = "";
              _searchController.clear();
            });
          },
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            'assets/logo/logo_without_name.png', // Adjust your logo path
            fit: BoxFit.contain,
            width: 30,
            height: 30,
          ),
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search for players...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        )
            : null,
        actions: _isSearching
            ? [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = "";
              });
            },
          )
        ]
            : [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF1877F2),
            ),
            tooltip: 'Search',
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Color(0xFF1877F2)),
            tooltip: 'Message',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF1877F2)),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').orderBy('exp', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          }

          var users = snapshot.data!.docs.where((doc) {
            var username = (doc.data() as Map<String, dynamic>)['username'].toString().toLowerCase();
            return _searchQuery.isEmpty || username.contains(_searchQuery.toLowerCase());
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Top Leaderboard image section
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewProfilePage()),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Leaderboard',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Rankings list
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index].data() as Map<String, dynamic>;
                      String username = user['username'] ?? 'Unknown';
                      int exp = user['exp'] ?? 0;
                      String? image = user['imageUrl']; // If user image is provided

                      return rankTile(
                        rank: index + 1,
                        name: username,
                        points: "$exp XP",
                        image: image,
                        highlight: username == "You",
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget rankTile({
    required int rank,
    required String name,
    required String points,
    String? image,
    bool highlight = false,
  }) {
    // Define different colors for the top 3 ranks
    Color backgroundColor;
    if (rank == 1) {
      backgroundColor = Colors.blue.shade400; // Gold for rank 1
    } else if (rank == 2) {
      backgroundColor = Colors.blue.shade300; // Silver for rank 2
    } else if (rank == 3) {
      backgroundColor = Colors.blue.shade200; // Bronze for rank 3
    } else {
      backgroundColor = Colors.grey.shade100; // Default for other ranks
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor, // Use the updated background color
        borderRadius: BorderRadius.circular(8), // Rounded corners for the container
        boxShadow: highlight
            ? [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Rank display
              Text(
                rank.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              // Circular Avatar placeholder
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.purple.shade100, // Set background color to match the screenshot
                child: image != null && image.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Display default image if there's an error loading the network image
                      return ClipOval(
                        child: Image.asset(
                          'assets/user/default.png', // Path to your default image
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                )
                    : ClipOval(
                  child: Image.asset(
                    'assets/user/default.png', // Path to your default image
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name and XP
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // XP badge with an icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.handshake, // Use a hand icon similar to the screenshot
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  points,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
