import 'package:flutter/material.dart';
import 'package:ocean_rescue/pages/post/create_post_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocean_rescue/resources/auth_methods.dart';
import 'package:ocean_rescue/widget/navbar/TopAppBar%20.dart';
import '../../theme/colorTheme.dart';
import '../../widget/feed/FeaturedEventSection.dart';
import '../../widget/feed/post_card.dart';
import '../../widget/navbar/BottomNavBar.dart';
import '../../models/user.dart'; // Import your user model

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> posts = [];
  bool isLoadingMore = false; // To track loading more posts
  bool hasMore = true; // To track if more posts are available
  DocumentSnapshot? lastPost; // Track the last post for pagination
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller for infinite scrolling
  String? userProfileImage; // Store the user profile image URL

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _loadUserProfile(); // Load user profile when initializing

    // Add listener to the scroll controller to detect when user scrolls down
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          hasMore &&
          !isLoadingMore) {
        _fetchMorePosts(); // Load more posts when we reach the bottom
      }
    });
  }

  // Fetch the user details including the profile picture
  Future<void> _loadUserProfile() async {
    try {
      // Use the getUserDetails method to get the user profile
      User currentUser = await AuthMethods().getUserDetails();
      setState(() {
        userProfileImage = currentUser.photoUrl; // Store the profile image URL
      });
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  // Fetch the first set of posts
  Future<void> _fetchPosts() async {
    try {
      setState(() {
        isLoadingMore = true; // Set loading state to true
      });

      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .limit(10) // Load first 10 posts
          .get();

      List<Map<String, dynamic>> fetchedPosts = [];

      for (var doc in postSnapshot.docs) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(doc['uid']).get();
        fetchedPosts.add({
          'postId': doc['postId'],
          'postUrl': doc['postUrl'],
          'description': doc['description'],
          'likes': doc['likes'],
          'datePublished': doc['datePublished'],
          'title': doc['title'],
          'uid': doc['uid'],
          'username': userDoc['username'],
          'profImage': userDoc['photoUrl'],
        });
      }

      setState(() {
        posts = fetchedPosts;
        lastPost = postSnapshot.docs.isNotEmpty ? postSnapshot.docs.last : null;
        hasMore = postSnapshot.docs.length ==
            10; // If we have exactly 10 posts, there may be more
      });
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      setState(() {
        isLoadingMore = false; // Set loading state to false
      });
    }
  }

  // Fetch more posts when scrolling
  Future<void> _fetchMorePosts() async {
    if (!hasMore || lastPost == null) return;

    try {
      setState(() {
        isLoadingMore = true; // Set loading state to true
      });

      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .startAfterDocument(lastPost!) // Fetch posts after the last post
          .limit(5) // Load the next 5 posts
          .get();

      List<Map<String, dynamic>> fetchedPosts = [];

      for (var doc in postSnapshot.docs) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(doc['uid']).get();
        fetchedPosts.add({
          'postId': doc['postId'],
          'postUrl': doc['postUrl'],
          'description': doc['description'],
          'likes': doc['likes'],
          'datePublished': doc['datePublished'],
          'title': doc['title'],
          'uid': doc['uid'],
          'username': userDoc['username'],
          'profImage': userDoc['photoUrl'],
        });
      }

      setState(() {
        posts.addAll(fetchedPosts); // Append new posts to the existing list
        lastPost = postSnapshot.docs.isNotEmpty ? postSnapshot.docs.last : null;
        hasMore = postSnapshot.docs.length ==
            10; // Check if there are more posts to load
      });
    } catch (e) {
      print("Error fetching more posts: $e");
    } finally {
      setState(() {
        isLoadingMore = false; // Set loading state to false
      });
    }
  }

  // Callback function to remove post
  void _removePost(String postId) {
    setState(() {
      posts.removeWhere((post) => post['postId'] == postId); // Remove the post
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.white,
      appBar: TopAppBar(selectedTabIndex: BottomNavBar.selectedTabIndex),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchPosts(); // Refresh the posts
        },
        child: SingleChildScrollView(
          controller: _scrollController, // Attach the scroll controller here
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
                      backgroundImage: userProfileImage != null
                          ? NetworkImage(
                              userProfileImage!) // Use the dynamic profile image
                          : const AssetImage('assets/user/profile_pic.jpg')
                              as ImageProvider, // Fallback if no image
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreatePostScreen()),
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
                                'Post what’s on your mind?',
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
              const FeaturedEventSection(),

              const SizedBox(height: 16),

              // Posts list (Lazy loading)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    posts.length + 1, // Extra item for the loading indicator
                itemBuilder: (ctx, index) {
                  if (index == posts.length) {
                    // Show loading indicator at the bottom if more posts are loading
                    return isLoadingMore
                        ? const Center(child: CircularProgressIndicator())
                        : Container();
                  }
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: PostCard(
                        snap: posts[index], // Pass the actual post data
                        onPostDeleted: _removePost, // Pass the delete callback
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Clean up the scroll controller
    super.dispose();
  }
}
