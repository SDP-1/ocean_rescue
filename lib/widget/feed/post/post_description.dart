// post_description.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class PostDescription extends StatelessWidget {
  final String username;
  final String title;
  final String description;
  final bool isDescriptionExpanded;
  final int likeCount;
  final int commentLen;
  final VoidCallback onToggleDescription;

  const PostDescription({
    super.key,
    required this.username,
    required this.title,
    required this.description,
    required this.isDescriptionExpanded,
    required this.likeCount,
    required this.commentLen,
    required this.onToggleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$likeCount likes',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const TextSpan(text: '\t\t\t'),
                      TextSpan(
                        text: title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                              ..onTap = onToggleDescription,
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
    );
  }
}
