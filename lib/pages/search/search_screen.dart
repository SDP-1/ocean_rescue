import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../../theme/colorTheme.dart';
import '../../models/user.dart' as AppUsers;
import 'end_userprofile_screen.dart' as end_user;

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of Firebase Auth

  List<AppUsers.User> users = []; // List to hold all users from Firestore
  List<AppUsers.User> filteredUsers = []; // List to hold filtered users
  bool isLoading = true;
  String currentUserId = ''; // Store current user's UID

  @override
  void initState() {
    super.initState();
    getCurrentUserId(); // Fetch current user's ID
    _searchController.addListener(filterUsers);
  }

  // Get the current user UID
  String fetchCurrentUserId() {
    return _auth.currentUser!.uid; // Get current user's UID from Firebase Auth
  }

  // Fetch the current user and all other users from Firestore
  Future<void> getCurrentUserId() async {
    setState(() {
      currentUserId = _auth.currentUser!.uid; // Fetch the logged-in user's UID
    });

    await fetchUsersFromFirestore(); // Fetch users from Firestore after getting the UID
  }

  // Fetch users from Firestore, excluding the current logged-in user
  Future<void> fetchUsersFromFirestore() async {
    try {
      // Retrieve users from the 'users' collection in Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Map the documents to User objects and filter out the current user
      setState(() {
        users = querySnapshot.docs
            .map((doc) => AppUsers.User.fromSnap(doc))
            .where((user) => user.uid != currentUserId) // Exclude current user
            .toList();

        filteredUsers =
            users; // Initially, display all users except current user
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter users based on the search query and exclude the current user
  void filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users
          .where((AppUsers.User user) =>
              user.username.toLowerCase().contains(query) &&
              user.uid != currentUserId) // Exclude current user
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
                  CircularProgressIndicator(), // Show a loading indicator while fetching users
            )
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
                            // Navigate to UserProfilePage and pass the userId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => end_user.UserProfilePage(
                                  userId: filteredUsers[index].uid,
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
