import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ocean_rescue/resources/post_firestore_methods.dart';
import '../../widget/feed/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final PostFireStoreMethods _fireStoreMethods = PostFireStoreMethods();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    List<Map<String, dynamic>> comments =
        await _fireStoreMethods.fetchCommentsWithUserData(widget.postId);
    setState(() {
      _comments = comments;
      _isLoading = false; // Set loading to false after fetching
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String result = await _fireStoreMethods.postComment(
        widget.postId, _commentController.text, uid);

    if (result == 'success') {
      _commentController.clear();
      _fetchComments();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : _comments.isEmpty
                      ? const Text(
                          'No comments yet. Be the first to comment!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      : ListView.builder(
                          itemCount: _comments.length,
                          itemBuilder: (context, index) =>
                              CommentCard(snap: _comments[index]),
                        ),
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...', // Placeholder text
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Border radius
                        borderSide: BorderSide.none, // No visible border
                      ),
                      filled: true, // To apply background color
                      fillColor: Colors
                          .grey[200], // Background color for the input field
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Colors.blue), // Send button with blue color
                  onPressed:
                      _postComment, // On press, call the post comment function
                ),
              ],
            ),
          )),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  16.0, // Adding 16 pixels of extra padding
            ),
          ),
        ],
      ),
    );
  }
}
