import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/pages/feed/comments_screen.dart';
import 'package:ocean_rescue/utils/colors.dart';
import 'package:ocean_rescue/resources/post_firestore_methods.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import '../../widget/feed/comment_card.dart';
import 'like_animation.dart'; // Ensure this file exists
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../popup/DeleteConfirmationPopup.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap; // Data from Firebase
  final Function(String postId)
      onPostDeleted; // Callback when a post is deleted

  const PostCard({
    Key? key,
    required this.snap,
    required this.onPostDeleted, // Add required parameter for onPostDeleted
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool isDescriptionExpanded = false; // State to control description expansion
  bool isLiked = false; // State to track if the post is liked
  late final String uid; // Current user's UID
  late int likeCount; // To track the number of likes

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID
    commentLen =
        widget.snap['comments']?.length ?? 0; // Get actual comment length

    // Initialize the liked state and listen for changes in the likes count
    isLiked = widget.snap['likes'].contains(uid);
    likeCount = widget.snap['likes'].length;

    // Listen to real-time updates for likes
    _listenToLikeUpdates();
  }

  void _listenToLikeUpdates() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        List<dynamic> updatedLikes = snapshot.data()?['likes'] ?? [];
        setState(() {
          likeCount = updatedLikes.length; // Update like count
          isLiked = updatedLikes
              .contains(uid); // Check if the current user has liked the post
        });
      }
    });
  }

  void deletePost(String postId) {
    PostFireStoreMethods().deletePost(postId).then((_) {
      widget.onPostDeleted(postId); // Call the onPostDeleted callback
    });
  }

  void showBottomSheetOptions(BuildContext context) {
    final String postOwnerId =
        widget.snap['uid']; // Get the UID of the post owner
    final String currentUserId =
        FirebaseAuth.instance.currentUser!.uid; // Get the current user's UID

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            // Share option available to all users
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Post'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality here
              },
            ),

            // Bookmark option available to all users
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Bookmark Post'),
              onTap: () {
                Navigator.pop(context);
                // Implement bookmark functionality here
              },
            ),

            // Check if the current user is the owner of the post
            if (currentUserId == postOwnerId) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Post'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit post screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Post'),
                onTap: () {
                  Navigator.pop(context);
                  // Show confirmation dialog with deletion logic
                  DeleteConfirmationPopup(
                    context,
                    'This post.', // Message to display
                    () => deletePost(
                        widget.snap['postId']), // Deletion action on confirm
                  );
                },
              ),
            ],

            // Cancel option to close the bottom sheet
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.snap['description'] ?? '';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showBottomSheetOptions(context);
                  },
                ),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () async {
              _toggleLike();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false; // Reset animation state
                        });
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isLiked
                            ? Colors.red
                            : Colors.white, // Change color based on isLiked
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: isLiked,
                smallLike: true,
                child: IconButton(
                  icon: isLiked
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border),
                  onPressed: () async {
                    _toggleLike();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  BottomNavBar.visibility(false);
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'],
                      ),
                    ),
                  )
                      .then((_) {
                    BottomNavBar.visibility(true);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Implement share functionality
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      // Implement bookmark functionality
                    },
                  ),
                ),
              ),
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$likeCount likes', // Updated to show real-time like count
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post title and username with space between them
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: widget
                                  .snap['username'], // Display the username
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  '\t\t\t', // Add some space between username and title
                            ),
                            TextSpan(
                              text: widget
                                  .snap['title'], // Display the post title
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display the description with "See more/See less" functionality
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: isDescriptionExpanded
                                    ? description
                                    : description.length > 100
                                        ? '${description.substring(0, 100)}... '
                                        : description,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              if (description.length > 100)
                                TextSpan(
                                  text: isDescriptionExpanded
                                      ? '  See less'
                                      : ' See more',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        isDescriptionExpanded =
                                            !isDescriptionExpanded; // Toggle expansion
                                      });
                                    },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'View all $commentLen comments',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleLike() async {
    // Optimistic UI update
    setState(() {
      isLikeAnimating = true;
      if (isLiked) {
        likeCount--; // Decrease the count
      } else {
        likeCount++; // Increase the count
      }
      isLiked = !isLiked; // Toggle liked state
    });

    // Perform Firestore update
    try {
      final response = await PostFireStoreMethods().likePost(
        widget.snap['postId'], // Post ID
        uid, // User ID
      );

      // Handle failure
      if (response != 'success') {
        // Revert the optimistic UI change if the Firestore update failed
        setState(() {
          if (isLiked) {
            likeCount--; // Rollback increase
          } else {
            likeCount++; // Rollback decrease
          }
          isLiked = !isLiked; // Revert liked state
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $response')),
        );
      }
    } catch (e) {
      // Revert UI in case of any exception
      setState(() {
        if (isLiked) {
          likeCount--; // Rollback increase
        } else {
          likeCount++; // Rollback decrease
        }
        isLiked = !isLiked; // Revert liked state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
