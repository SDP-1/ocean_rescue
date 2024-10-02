import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/colorTheme.dart';
import '../../models/user.dart';
import 'end_userprofile_screen.dart' as end_user;

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<User> users = []; // List to hold all users from Firestore
  List<User> filteredUsers = []; // List to hold filtered users

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(filterUsers);
    fetchUsersFromFirestore(); // Fetch users from Firestore
  }

  // Fetch users from Firestore
  Future<void> fetchUsersFromFirestore() async {
    try {
      // Retrieve users from the 'users' collection in Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Map the documents to User objects and set the state
      setState(() {
        users = querySnapshot.docs.map((doc) => User.fromSnap(doc)).toList();
        filteredUsers = users; // Initially, display all users
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter users based on the search query
  void filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((user) => user.username.toLowerCase().contains(query))
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              filled: true,
              fillColor: ColorTheme.liteBlue2, // Set to a light blue background
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while fetching users
          : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(filteredUsers[index]
                                .photoUrl), // Use photoUrl from Firestore
                            radius: 24,
                          ),
                          title: Text(
                            filteredUsers[index]
                                .username, // Use username from Firestore
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          onTap: () {
                            // Navigate to UserProfilePage and pass the user.uid
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => end_user.UserProfilePage(
                                  userId: filteredUsers[index].uid, // Pass user ID
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
            ),
    );
  }
}
