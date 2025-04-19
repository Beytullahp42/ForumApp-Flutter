import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forum_app_ui/components/profile_picture.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/comment.dart';
import '../services/api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class commentTile extends StatefulWidget {
  final Comment comment;

  const commentTile({super.key, required this.comment});

  @override
  State<commentTile> createState() => _commentTileState();
}

class _commentTileState extends State<commentTile> {
  late Comment comment;
  late bool _isLiked;
  late bool _isDisliked;
  late int _likeCount;
  late int _dislikeCount;

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
    _isLiked = comment.isLiked;
    _isDisliked = comment.isDisliked;
    _likeCount = comment.likeCount;
    _dislikeCount = comment.dislikeCount;
  }

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return int.tryParse(prefs.getString('userId')!) ?? -1; // Default to -1 if not found
  }

  void _handleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likeCount--;
      } else {
        _isLiked = true;
        _likeCount++;
        if (_isDisliked) {
          _isDisliked = false;
          _dislikeCount--;
        }
      }
    });
    ApiCalls.likeComment(comment.id);
  }

  void _handleDislike() {
    setState(() {
      if (_isDisliked) {
        _isDisliked = false;
        _dislikeCount--;
      } else {
        _isDisliked = true;
        _dislikeCount++;
        if (_isLiked) {
          _isLiked = false;
          _likeCount--;
        }
      }
    });
    ApiCalls.dislikeComment(comment.id);
  }

  void _deleteComment() async {
    final success = await ApiCalls.deleteComment(comment.id);
    if (success) {
      Fluttertoast.showToast(msg: "Comment Deleted Successfully");
      // You might want to call a function here to refresh the comments list
    } else {
      Fluttertoast.showToast(msg: "Failed to delete comment");
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = timeago.format(comment.createdAt, locale: 'en_short');

    return FutureBuilder<int>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Just return an empty container or any placeholder, since no circular progress indicator is needed
          return Container();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(); // Handle any error case here
        }

        final userId = snapshot.data!;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ProfilePicture(emojiText: comment.user.profilePicture, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                comment.user.name,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(comment.content,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formattedDate),
                        Row(
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  onPressed: _handleLike,
                                  icon: Icon(
                                    _isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_alt_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(_likeCount.toString()),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: _handleDislike,
                                  icon: Icon(
                                    _isDisliked
                                        ? Icons.thumb_down
                                        : Icons.thumb_down_alt_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(_dislikeCount.toString()),
                              ],
                            ),
                            if (comment.user.id == userId)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.black),
                                onPressed: () {
                                  // Show confirmation dialog before deletion
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Comment'),
                                        content: const Text('Are you sure you want to delete this comment?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _deleteComment(); // Call the delete function
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
