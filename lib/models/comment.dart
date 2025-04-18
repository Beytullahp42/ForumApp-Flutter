import 'user.dart';

class Comment {
  final int id;
  final String content;
  final int likeCount;
  final int dislikeCount;
  final User user;

  Comment({
    required this.id,
    required this.content,
    required this.likeCount,
    required this.dislikeCount,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    content: json['p_content'],
    likeCount: json['like_count'],
    dislikeCount: json['dislike_count'],
    user: User.fromJson(json['user']),
  );
}
