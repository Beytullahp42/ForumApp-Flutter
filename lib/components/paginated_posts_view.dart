import 'package:flutter/material.dart';
import 'package:forum_app_ui/models/post.dart';
import 'package:forum_app_ui/models/paginated_response.dart';
import 'package:forum_app_ui/services/http_service.dart';
import '../components/post_tile.dart';
import 'dart:convert';

class PaginatedPostsWidget extends StatefulWidget {
  final PaginatedResponse<Post> initialResponse;

  const PaginatedPostsWidget({
    super.key,
    required this.initialResponse,
  });

  @override
  State<PaginatedPostsWidget> createState() => _PaginatedPostsWidgetState();
}

class _PaginatedPostsWidgetState extends State<PaginatedPostsWidget> {
  late PaginatedResponse<Post> _posts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _posts = widget.initialResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _posts.data.length,
            itemBuilder: (context, index) {
              return postTile(post: _posts.data[index]);
            },
          ),
        ),
        _buildPaginationControls(),
      ],
    );
  }


  Widget _buildPaginationControls() {
    final ButtonStyle squareButtonStyle = FilledButton.styleFrom(
      fixedSize: const Size(48, 48), // square shape
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // make it 0 for perfect square
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton(
            onPressed: _posts.currentPage > 1 ? () => _loadPage(_posts.firstPageUrl) : null,
            style: squareButtonStyle,
            child: const Text("<<", textAlign: TextAlign.center),
          ),
          FilledButton(
            onPressed: _posts.prevPageUrl != null ? () => _loadPage(_posts.prevPageUrl) : null,
            style: squareButtonStyle,
            child: const Text("<", textAlign: TextAlign.center),
          ),
          Text(
            "${_posts.currentPage}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          FilledButton(
            onPressed: _posts.nextPageUrl != null ? () => _loadPage(_posts.nextPageUrl) : null,
            style: squareButtonStyle,
            child: const Text(">", textAlign: TextAlign.center),
          ),
          FilledButton(
            onPressed: _posts.currentPage < _posts.lastPage ? () => _loadPage(_posts.lastPageUrl) : null,
            style: squareButtonStyle,
            child: const Text(">>", textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPage(String? fullUrl) async {
    if (fullUrl == null || _isLoading) return;

    // Strip base URL
    final baseUrl = "https://beytullahpaytar.com.tr/api/";
    final endpoint = fullUrl.replaceFirst(baseUrl, "");

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await HttpService.get(endpoint);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _posts = PaginatedResponse<Post>.fromJson(
            data,
                (json) => Post.fromJson(json),
          );
        });
      } else {
        throw Exception('Failed to load posts from $endpoint');
      }
    } catch (e) {
      print("Pagination error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
