import 'package:flutter/material.dart';
import 'package:forum_app_ui/routes.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/post.dart';
import '../services/api_calls.dart';
import 'color_option.dart';

class postTile extends StatefulWidget {
  final Post post;
  final isClickable;

  const postTile({super.key, required this.post, this.isClickable = true});

  @override
  State<postTile> createState() => _postTileState();
}

class _postTileState extends State<postTile> {
  late Post post;
  late bool _isLiked;
  late bool _isDisliked;
  late int _likeCount;
  late int _dislikeCount;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _isLiked = post.isLiked;
    _isDisliked = post.isDisliked;
    _likeCount = post.likeCount;
    _dislikeCount = post.dislikeCount;
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
    ApiCalls.likePost(post.id);
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
    ApiCalls.dislikePost(post.id);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = timeago.format(post.createdAt, locale: 'en_short');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: ColorOption.getColorByName(post.color),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () { widget.isClickable ?
                      Navigator.pushNamed(
                        context,
                        AppRoutes.post,
                        arguments: post.id, // Pass the post ID to the PostPage
                      ) : {};
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text(
                              post.user.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.userPage,
                                arguments: post.user.id,
                              );
                            }
                          ),
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(post.content),
                        ],
                      ),
                    ),
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
  }
}
