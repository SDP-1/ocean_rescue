import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

class UserProfilePage extends StatelessWidget {
  final String userId; // Accept user ID from previous screen

  const UserProfilePage({super.key, required this.userId});

  // Fetch user details from Firestore using the userId
  Future<User> fetchUserDetails(String userId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return User.fromSnap(doc); // Parse the document into a User object
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: fetchUserDetails(userId), // Fetch user data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body:
                Center(child: CircularProgressIndicator()), // Loading indicator
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body:
                Center(child: Text('Error loading user data')), // Error message
          );
        } else if (snapshot.hasData) {
          User user = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(user.username), // Display user's name
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center content horizontally
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile image and username on the left
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align name with profile image
                          children: [
                            Container(
                              width: 100, // Set the width you want
                              height: 100, // Set the height you want
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user
                                      .photoUrl), // Fetch image from Firestore
                                  fit: BoxFit
                                      .cover, // Ensures the image fits within the circle
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 8), // Space between image and name
                          ],
                        ),
                        const SizedBox(
                            width: 20), // Spacing between image and details

                        // Stats and follow button on the right
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align stats and button to the left
                            children: [
                              // Stats (Post, Followers, Following)
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: 12, // Reduced font size
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Post',
                                        style: TextStyle(
                                            fontSize: 10), // Reduced font size
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          fontSize: 12, // Reduced font size
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                            fontSize: 10), // Reduced font size
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          fontSize: 12, // Reduced font size
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Following',
                                        style: TextStyle(
                                            fontSize: 10), // Reduced font size
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Follow button with expanded width
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        fontSize: 12), // Reduced font size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20.0,
                        right: 16.0,
                        bottom: 4.0), // Adjust margins as needed
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis, // Truncate with "..."
                        maxLines: 2, // Restrict to two lines if needed
                      ),
                    ),
                  ),
                  const Divider(),
                  // Medal section with horizontal centering
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/medals/bronze.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(
                            width:
                                8), // Add some space between the image and the text
                        const Text(
                          'Member',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
                child: Text('User not found')), // In case user data is missing
          );
        }
      },
    );
  }
}
