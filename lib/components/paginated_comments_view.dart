import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forum_app_ui/models/comment.dart';
import 'package:forum_app_ui/models/paginated_response.dart';
import 'package:forum_app_ui/services/http_service.dart';
import 'comment_tile.dart';

class PaginatedCommentsWidget extends StatefulWidget {
  final int postId;
  final PaginatedResponse<Comment> initialResponse;

  const PaginatedCommentsWidget({
    super.key,
    required this.postId,
    required this.initialResponse,
  });

  @override
  State<PaginatedCommentsWidget> createState() =>
      _PaginatedCommentsWidgetState();
}

class _PaginatedCommentsWidgetState extends State<PaginatedCommentsWidget> {
  late PaginatedResponse<Comment> _comments;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _comments = widget.initialResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: _comments.data.length,
                    itemBuilder: (context, index) {
                      return commentTile(comment: _comments.data[index]);
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
            onPressed:
                _comments.currentPage > 1
                    ? () => _loadPage(_comments.firstPageUrl)
                    : null,
            style: squareButtonStyle,
            child: const Text("<<", textAlign: TextAlign.center),
          ),
          FilledButton(
            onPressed:
                _comments.prevPageUrl != null
                    ? () => _loadPage(_comments.prevPageUrl)
                    : null,
            style: squareButtonStyle,
            child: const Text("<", textAlign: TextAlign.center),
          ),
          Text(
            "${_comments.currentPage}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          FilledButton(
            onPressed:
                _comments.nextPageUrl != null
                    ? () => _loadPage(_comments.nextPageUrl)
                    : null,
            style: squareButtonStyle,
            child: const Text(">", textAlign: TextAlign.center),
          ),
          FilledButton(
            onPressed:
                _comments.currentPage < _comments.lastPage
                    ? () => _loadPage(_comments.lastPageUrl)
                    : null,
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
    final baseUrl =
        "https://beytullahpaytar.com.tr/api/"; // Replace with your base URL
    final endpoint = fullUrl.replaceFirst(baseUrl, "");

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await HttpService.get(endpoint);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _comments = PaginatedResponse<Comment>.fromJson(
            data,
            (json) => Comment.fromJson(json), // Replace with your Comment class
          );
        });
      } else {
        throw Exception('Failed to load comments from $endpoint');
      }
    } catch (e) {
      print("Pagination error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
