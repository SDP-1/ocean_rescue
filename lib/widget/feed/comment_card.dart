import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Timestamp

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> snap;

  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    final String profilePic = snap['profilePic'];
    final String name = snap['name'];
    final String text = snap['text'];
    final String uid = snap['uid'];
    final String commentId = snap['commentId'];

    // Handle both Timestamp and DateTime
    final datePublished = snap['datePublished'];
    DateTime? parsedDate;
    if (datePublished is Timestamp) {
      parsedDate = datePublished.toDate();
    } else if (datePublished is DateTime) {
      parsedDate = datePublished;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePic),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: ' $text',
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (parsedDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(parsedDate),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
