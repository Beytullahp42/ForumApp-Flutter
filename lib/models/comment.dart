import 'user.dart';

class Comment {
  final int id;
  final String content;
  final int likeCount;
  final int dislikeCount;
  final User user;
  final bool isLiked;
  final bool isDisliked;
  final DateTime createdAt;
  final int postId;

  Comment({
    required this.id,
    required this.content,
    required this.likeCount,
    required this.dislikeCount,
    required this.user,
    required this.isLiked,
    required this.isDisliked,
    required this.createdAt,
    required this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    content: json['p_content'],
    likeCount: json['like_count'],
    dislikeCount: json['dislike_count'],
    user: User.fromJson(json['user']),
    isLiked: json['is_liked'] ?? false,
    isDisliked: json['is_disliked'] ?? false,
    createdAt: DateTime.parse(json['created_at']),
    postId: json['post_id'],
  );
}
