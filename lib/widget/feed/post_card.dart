import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './post/PostHeader.dart';
import './post/post_image.dart';
import './post/post_actions.dart';
import './post/post_description.dart';
import './post/post_options_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocean_rescue/pages/feed/comments_screen.dart';
import 'package:ocean_rescue/pages/post/UpdatePostScreen.dart';
import '../popup/DeleteConfirmationPopup.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final Function(String postId) onPostDeleted;

  const PostCard({
    super.key,
    required this.snap,
    required this.onPostDeleted,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isDescriptionExpanded = false;
  bool isLiked = false;
  bool isLikeAnimating = false;
  int likeCount = 0;
  int commentLen = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late StreamSubscription<DocumentSnapshot> _likesListener;

  @override
  void initState() {
    super.initState();
    isLiked = widget.snap['likes'].contains(uid);
    likeCount = widget.snap['likes'].length;
    commentLen = widget.snap['comments']?.length ?? 0;

    _startLikesListener();
  }

  void _startLikesListener() {
    _likesListener = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final likes = snapshot.data()?['likes'] as List<dynamic>;
        setState(() {
          likeCount = likes.length; // Update like count
          isLiked = likes.contains(uid); // Update if current user has liked
        });
      }
    });
  }

  @override
  void dispose() {
    _likesListener.cancel();
    super.dispose();
  }

  void _toggleLike() async {
    // Optimistically update the like count in the UI
    setState(() {
      isLiked = !isLiked; // Toggle liked state
      isLikeAnimating = true; // Start animation
      likeCount += isLiked ? 1 : -1; // Increment or decrement like count
    });

    // Update Firestore with the like or unlike action
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .update({
        'likes': isLiked
            ? FieldValue.arrayUnion([uid])
            : FieldValue.arrayRemove([uid]),
      });
    } catch (e) {
      print("Error liking the post: $e");
    }

    // Stop like animation after 400ms
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        isLikeAnimating = false; // Reset animation state
      });
    });
  }

  void _toggleDescription() {
    setState(() {
      isDescriptionExpanded = !isDescriptionExpanded;
    });
  }

  void _deletePost() {
    DeleteConfirmationPopup(
      context,
      'This post.',
      () async {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .delete();
        widget.onPostDeleted(widget.snap['postId']);
      },
    );
  }

  void _sharePost() {
    final postUrl = widget.snap['postUrl'];
    final postTitle = widget.snap['title'];
    final postDescription = widget.snap['description'];
    Share.share(
      'Check out this post: $postTitle\n\n$postDescription\n$postUrl',
      subject: 'Check out this post on Ocean Rescue!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          PostHeader(
            profileImageUrl: widget.snap['profImage'],
            username: widget.snap['username'],
            onOptionsPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => PostOptionsBottomSheet(
                onShare: _sharePost,
                onBookmark: () {},
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePostScreen(
                        post: widget.snap,
                      ),
                    ),
                  );
                },
                onDelete: _deletePost,
                currentUserId: FirebaseAuth
                    .instance.currentUser!.uid, // Pass current user ID
                postOwnerId: widget.snap['uid'],
              ),
            ),
          ),
          PostImage(
            imageUrl: widget.snap['postUrl'],
            isLikeAnimating: isLikeAnimating,
            isLiked: isLiked,
            onDoubleTap: _toggleLike,
            onAnimationEnd: () {
              setState(() {
                isLikeAnimating = false;
              });
            },
          ),
          PostActions(
            isLiked: isLiked,
            onLikePressed: _toggleLike,
            onCommentPressed: () {
              BottomNavBar.visibility(false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    postId: widget.snap['postId'],
                  ),
                ),
              ).then((_) {
                BottomNavBar.visibility(true);
              });
            },
            onSharePressed: _sharePost,
            onBookmarkPressed: () {},
          ),
          PostDescription(
            username: widget.snap['username'],
            title: widget.snap['title'],
            description: widget.snap['description'],
            isDescriptionExpanded: isDescriptionExpanded,
            likeCount: likeCount,
            commentLen: commentLen,
            onToggleDescription: _toggleDescription,
          ),
        ],
      ),
    );
  }
}
