// post_image.dart
import 'package:flutter/material.dart';
import 'package:ocean_rescue/widget/feed/post/like_animation.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final bool isLikeAnimating;
  final bool isLiked;
  final VoidCallback onDoubleTap;
  final VoidCallback onAnimationEnd;

  const PostImage({
    super.key,
    required this.imageUrl,
    required this.isLikeAnimating,
    required this.isLiked,
    required this.onDoubleTap,
    required this.onAnimationEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isLikeAnimating ? 1 : 0,
            child: LikeAnimation(
              isAnimating: isLikeAnimating,
              duration: const Duration(milliseconds: 400),
              onEnd: onAnimationEnd,
              child: Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.white,
                size: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
