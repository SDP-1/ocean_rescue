import 'package:flutter/material.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'end_userprofile_screen.dart'; // Add this line

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<User> users = [
    User(name: 'Sehan Devinda', imageUrl: 'assets/user/user1.jpg'),
    User(name: 'Sanul', imageUrl: 'assets/user/user2.jpg'),
    User(name: 'Pasan', imageUrl: 'assets/user/user3.jpg'),
  ];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
    _searchController.addListener(() {
      filterUsers();
    });
  }

  void filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((user) => user.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              filled: true,
              fillColor:
                  ColorTheme.liteBlue2, // Set to a light greenish background
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none, // Removes the border
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 8.0), // Adjust top padding for a clean look
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(filteredUsers[index].imageUrl),
                      radius: 24, // Adjust size to closely match the image
                    ),
                    title: Text(
                      filteredUsers[index].name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(user: filteredUsers[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
