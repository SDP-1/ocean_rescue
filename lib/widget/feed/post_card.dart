import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/utils/colors.dart';
import '../../pages/feed/comments_screen.dart';
import '../../widget/feed/comment_card.dart';
import 'like_animation.dart'; // Ensure this file exists

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap; // Placeholder for post data
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

  @override
  void initState() {
    super.initState();
    // Initialize comment length based on sample data or replace with actual logic
    commentLen = widget.snap['comments']?.length ?? 0;
  }

  void deletePost(String postId) {
    setState(() {
      // Custom logic for deleting a post (if needed)
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLiked = widget.snap['likes']
        .contains('user_id'); // Replace 'user_id' with actual user ID

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
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      AssetImage(widget.snap['profImage'].toString()),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Open a dialog to delete the post
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                  child: const Text('Delete'),
                                ),
                                onTap: () {
                                  deletePost(widget.snap['postId'].toString());
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
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
                  child: Image.asset(
                    widget.snap['postUrl'].toString(),
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
                      Future.delayed(const Duration(milliseconds: 400), () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      });
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
                        postId: widget.snap['postId'].toString(),
                        comments: [
                          {
                            'profilePic': 'https://example.com/profile1.jpg',
                            'name': 'Alice',
                            'text': 'Great post!',
                            'datePublished': DateTime.now(),
                          },
                          {
                            'profilePic': 'https://example.com/profile2.jpg',
                            'name': 'Bob',
                            'text': 'Thanks for sharing!',
                            'datePublished': DateTime.now()
                                .subtract(const Duration(days: 1)),
                          },
                        ],
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.snap['likes']?.length ?? 0} likes',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: widget.snap['username'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
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
                    DateFormat.yMMMd().format(
                      DateTime.now(), // Directly use DateTime
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
