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
      appBar: AppBar(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index].data() as Map<String, dynamic>;
                      String username = user['username'] ?? 'Unknown';
                      int exp = user['exp'] ?? 0;
                      String? image = user['imageUrl']; // If user image is provided

                      // Determine background color and highlight for the current user
                      Color backgroundColor;
                      if (index == 0) {
                        backgroundColor = Colors.blue.shade100;
                      } else if (index == 1) {
                        backgroundColor = Colors.blue.shade200;
                      } else if (index == 2) {
                        backgroundColor = Colors.blue.shade300;
                      } else if (username == "You") {
                        backgroundColor = Colors.blue.shade400;
                      } else {
                        backgroundColor = Colors.grey.shade200;
                      }

                      return rankTile(
                        rank: index + 1,
                        name: username,
                        points: "$exp XP",
                        image: image,
                        backgroundColor: backgroundColor,
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
    required Color backgroundColor,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: highlight
            ? [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ]
            : [],
      ),
      child: Row(
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
          const SizedBox(width: 16),
          // Avatar only for top 3 ranks (1st, 2nd, and 3rd place)
          if (rank <= 3 && image != null)
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(image),
            ),
          if (rank <= 3 && image != null) const SizedBox(width: 16),
          // Name and points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  points,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          // Highlight badge for top 3 ranks
          if (rank <= 3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "#$rank",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }


}

