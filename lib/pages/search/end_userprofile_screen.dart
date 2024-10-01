import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(user.name),
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
                            image: AssetImage(user.imageUrl),
                            fit: BoxFit
                                .cover, // Ensures the image fits within the circle
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Space between image and name
                    ],
                  ),
                  const SizedBox(width: 20), // Spacing between image and details

                  // Stats and follow button on the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align stats and button to the left
                      children: [
                        // Stats (Post, Followers, Following)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              style:
                                  TextStyle(fontSize: 12), // Reduced font size
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
                  user.name,
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
  }
}

class User {
  final String name;
  final String imageUrl;

  User({required this.name, required this.imageUrl});
}
