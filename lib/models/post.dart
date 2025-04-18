import 'user.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String color;
  final int likeCount;
  final int dislikeCount;
  final User user;
  final DateTime createdAt;
  final bool isLiked;
  final bool isDisliked;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.likeCount,
    required this.dislikeCount,
    required this.user,
    required this.createdAt,
    required this.isLiked,
    required this.isDisliked,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    title: json['title'],
    content: json['p_content'],
    color: json['color'],
    likeCount: json['like_count'],
    dislikeCount: json['dislike_count'],
    user: User.fromJson(json['user']),
    createdAt: DateTime.parse(json['created_at']),
    isLiked: json['is_liked'] ?? false,
    isDisliked: json['is_disliked'] ?? false,
  );
}

Post placeHolderPost = Post(
  id: 0,
  title: "Loading...",
  content: "Loading...",
  color: "#FFFFFF",
  likeCount: 0,
  dislikeCount: 0,
  user: User(
    id: 0,
    name: "Loading...",
    email: "Loading...",
    profilePicture: "Loading...",
  ),
  createdAt: DateTime.now(),
  isLiked: false,
  isDisliked: false,
);
