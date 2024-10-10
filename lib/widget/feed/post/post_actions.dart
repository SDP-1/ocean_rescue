// post_actions.dart
import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/feed/post/like_animation.dart';

class PostActions extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onBookmarkPressed;

  const PostActions({
    Key? key,
    required this.isLiked,
    required this.onLikePressed,
    required this.onCommentPressed,
    required this.onSharePressed,
    required this.onBookmarkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        LikeAnimation(
          isAnimating: isLiked,
          smallLike: true,
          child: IconButton(
            icon: isLiked
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border),
            onPressed: onLikePressed,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: onCommentPressed,
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: onSharePressed,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: onBookmarkPressed,
            ),
          ),
        ),
      ],
    );
  }
}
