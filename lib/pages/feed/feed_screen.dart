import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/post/create_post_screen.dart';

import '../../theme/colorTheme.dart';
import '../../widget/feed/FeaturedEventSection.dart';
import '../../widget/feed/TopAppBar .dart';
import '../../widget/feed/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.white,
      appBar: TopAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post what's on your mind section
            Container(
              padding: const EdgeInsets.all(10),
              color: ColorTheme.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/user/profile_pic.jpg'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print('Container tapped!');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CreatePostScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorTheme.liteBlue2, // Background color
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              'Post what’s on your mind ?',
                              style: TextStyle(
                                color: Colors.grey
                                    .shade600, // Text color to simulate placeholder text
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Featured Events Section
            FeaturedEventSection(),

            const SizedBox(height: 16), // Space between events and posts

            // Posts list (Scrollable)
            ListView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
              shrinkWrap: true, // Shrinks the list to fit the content
              itemCount:
                  10, // Set a static item count or fetch data from a different source
              itemBuilder: (ctx, index) => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                child: PostCard(
                  snap:
                      mockPostData, // You can pass in static data or use a different data source
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final Map<String, dynamic> mockPostData = {
  'postId': '12345',
  'profImage': 'assets/user/profile_pic.jpg',
  'username': 'john_doe',
  'postUrl': 'assets/post/post01.png',
  'description': 'This is a sample post description.',
  'likes': ['user1', 'user2', 'user3'], // Example user IDs who liked the post
  'datePublished': DateTime.now(), // Current date for testing
};
