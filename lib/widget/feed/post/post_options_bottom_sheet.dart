import 'package:flutter/material.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onBookmark;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String currentUserId;  // Current logged-in user's ID
  final String postOwnerId;     // ID of the post owner

  const PostOptionsBottomSheet({
    super.key,
    required this.onShare,
    required this.onBookmark,
    this.onEdit,
    this.onDelete,
    required this.currentUserId,
    required this.postOwnerId,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share Post'),
          onTap: onShare,
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Bookmark Post'),
          onTap: onBookmark,
        ),
        // Only show edit option if the current user is the post owner
        if (currentUserId == postOwnerId && onEdit != null) 
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Post'),
            onTap: onEdit,
          ),
        // Only show delete option if the current user is the post owner
        if (currentUserId == postOwnerId && onDelete != null) 
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Post'),
            onTap: onDelete,
          ),
        ListTile(
          leading: const Icon(Icons.cancel),
          title: const Text('Cancel'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
