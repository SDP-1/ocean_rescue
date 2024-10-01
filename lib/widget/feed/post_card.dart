import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/pages/feed/comments_screen.dart';
import 'package:ocean_rescue/utils/colors.dart';
import '../../widget/feed/comment_card.dart';
import 'like_animation.dart'; // Ensure this file exists

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap; // Data from Firebase
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool isDescriptionExpanded = false; // State to control description expansion

  @override
  void initState() {
    super.initState();
    commentLen =
        widget.snap['comments']?.length ?? 0; // Get actual comment length
  }

  void deletePost(String postId) {
    // Custom logic for deleting a post (implement as needed)
    // For example, call Firestore delete method
  }

  void showBottomSheetOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
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
                deletePost(widget.snap['postId']);
              },
            ),
            const Divider(),
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
    final bool isLiked = widget.snap['likes']
        .contains('user_id'); // Replace 'user_id' with actual user ID
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
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
              Future.delayed(const Duration(milliseconds: 400), () {
                setState(() {
                  isLikeAnimating = false;
                });
              });
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
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
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
                  onPressed: () {
                    setState(() {
                      // Replace with your like action
                      isLikeAnimating = true;
                      // Update likes in Firestore
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'],
                      ),
                    ),
                  );
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
                  '${widget.snap['likes']?.length ?? 0} likes',
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
                      // Display the description with a tab space and "See more/Show less" functionality
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
                                      ? 'See less'
                                      : 'See more',
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
