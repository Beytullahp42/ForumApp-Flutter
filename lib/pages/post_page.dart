import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forum_app_ui/components/post_tile.dart';
import 'package:forum_app_ui/components/paginated_comments_view.dart';
import 'package:forum_app_ui/components/unfocus_wrapper.dart';
import 'package:forum_app_ui/models/comment.dart';
import 'package:forum_app_ui/models/paginated_response.dart';
import 'package:forum_app_ui/models/post.dart';
import 'package:forum_app_ui/services/api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class PostPage extends StatefulWidget {
  final int postId;

  const PostPage({super.key, required this.postId});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with RouteAware {
  String? _commentErrorText;
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingComment = false;
  late Future<Post> postFuture;
  late Future<PaginatedResponse<Comment>> commentsFuture;
  int? userId;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _getUserId();
  }

  void _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = int.tryParse(prefs.getString('userId') ?? '');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
    _commentController.dispose();
  }

  @override
  void didPopNext() {
    checkConnection(context);
    _fetchData();
  }

  @override
  void didPush() {
    checkConnection(context);
  }

  void _fetchData() {
    postFuture = ApiCalls.getPost(widget.postId);
    commentsFuture = ApiCalls.getComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusOnTap(
        child: FutureBuilder<Post>(
          future: postFuture,
          builder: (context, postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (postSnapshot.hasData) {
              final post = postSnapshot.data!;

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Post Page'),
                  actions:
                      userId == post.user.id
                          ? [
                            IconButton(
                              icon: const Icon(Icons.delete_outlined),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Delete Post'),
                                      content: const Text(
                                        'Are you sure you want to delete this post?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await ApiCalls.deletePost(
                                              widget.postId,
                                            );
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Fluttertoast.showToast(msg: "Post deleted successfully");
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ]
                          : [],
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      postTile(post: post, isClickable: false),
                      const Text('Comments', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: FutureBuilder<PaginatedResponse<Comment>>(
                          future: commentsFuture,
                          builder: (context, commentsSnapshot) {
                            if (commentsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (commentsSnapshot.hasData) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  setState(() => _fetchData());
                                },
                                child: PaginatedCommentsWidget(
                                  initialResponse: commentsSnapshot.data!,
                                  postId: widget.postId,
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('Failed to load comments.'),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                labelText: 'Add a comment',
                                border: const OutlineInputBorder(),
                                errorText: _commentErrorText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () async {
                              final content = _commentController.text.trim();
                              if (content.isEmpty) {
                                setState(() {
                                  _commentErrorText = 'Comment cannot be empty';
                                });
                                return;
                              }
                              setState(() {
                                _isPostingComment = true;
                                _commentErrorText =
                                    null; // clear any previous error
                              });
                              final success = await ApiCalls.createComment(
                                widget.postId,
                                content,
                              );
                              if (success) {
                                Fluttertoast.showToast(
                                  msg: 'Comment posted successfully',
                                );
                                _commentController.clear();
                                _fetchData(); // Refresh comments
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Failed to post comment',
                                );
                              }
                              setState(() => _isPostingComment = false);
                            },
                            child:
                                _isPostingComment
                                    ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (postSnapshot.hasError) {
              return Center(
                child: Text('Failed to load post. ${postSnapshot.error}'),
              );
            }
            return const Center(child: Text('Failed to load post.'));
          },
        ),
      ),
    );
  }
}
