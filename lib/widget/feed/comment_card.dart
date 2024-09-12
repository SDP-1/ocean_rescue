import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_rescue/utils/colors.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> snap; // Ensure snap is a Map<String, dynamic>
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap['profilePic'], // Access profilePic directly
            ),
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
                            text: snap['name'], // Access name directly
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            )),
                        TextSpan(
                          text: ' ${snap['text']}', // Access text directly
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap['datePublished'] as DateTime, // Directly use DateTime
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: primaryColor,
                      ),
                    ),
                  )
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
          )
        ],
      ),
    );
  }
}
