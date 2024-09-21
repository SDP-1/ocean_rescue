class Post {
  final String title;
  final String description;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final List likes;

  Post({
    required this.title,
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'uid': uid,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'likes': likes,
    };
  }
}
