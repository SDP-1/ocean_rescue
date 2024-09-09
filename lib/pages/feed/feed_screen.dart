import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_rescue/utils/colors.dart';
import 'package:ocean_rescue/widget/feed/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor, // Set a single background color
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/logo_normal.png',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
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
    );
  }
}

// Define static data
final Map<String, dynamic> mockPostData = {
  'postId': '12345',
  'profImage': 'https://example.com/profile_image.jpg',
  'username': 'john_doe',
  'postUrl': 'https://example.com/post_image.jpg',
  'description': 'This is a sample post description.',
  'likes': ['user1', 'user2', 'user3'], // Example user IDs who liked the post
  'datePublished': DateTime.now(), // Current date for testing
};
