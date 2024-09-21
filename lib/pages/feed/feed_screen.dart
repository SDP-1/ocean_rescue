import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/post/create_post_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .get();
      List<Map<String, dynamic>> fetchedPosts = [];

      for (var doc in postSnapshot.docs) {
        // Get user details based on the post's uid
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(doc['uid']).get();
        fetchedPosts.add({
          'postId': doc['postId'],
          'postUrl': doc['postUrl'],
          'description': doc['description'],
          'likes': doc['likes'],
          'datePublished': doc['datePublished'],
          'username': userDoc['username'],
          'profImage': userDoc['photoUrl'], // Get user photo URL
        });
      }

      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

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
                    backgroundImage: AssetImage(
                        'assets/user/profile_pic.jpg'), // Placeholder
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePostScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorTheme.liteBlue2,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              'Post what’s on your mind ?',
                              style: TextStyle(
                                color: Colors.grey.shade600,
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

            const SizedBox(height: 16),

            // Posts list (Scrollable)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (ctx, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: PostCard(
                  snap: posts[index], // Pass the actual post data
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
