// post_header.dart
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final VoidCallback onOptionsPressed;

  const PostHeader({
    Key? key,
    required this.profileImageUrl,
    required this.username,
    required this.onOptionsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onOptionsPressed,
          ),
        ],
      ),
    );
  }
}
