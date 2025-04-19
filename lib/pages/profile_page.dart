import 'package:flutter/material.dart';
import 'package:forum_app_ui/components/profile_picture.dart';
import 'package:forum_app_ui/models/post.dart';
import 'package:forum_app_ui/routes.dart';

import '../components/paginated_posts_view.dart';
import '../main.dart';
import '../models/paginated_response.dart';
import '../models/user.dart';
import '../services/api_calls.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware{
  late Future<User> userFuture;
  late Future<PaginatedResponse<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    userFuture = ApiCalls.getUser();
    postsFuture = ApiCalls.getUserPosts();
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
  }

  @override
  void didPopNext() {
    checkConnection(context);
    userFuture = ApiCalls.getUser();
    postsFuture = ApiCalls.getUserPosts();
  }

  @override
  void didPush() {
    checkConnection(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings, arguments: userFuture);
            },
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(child: Text("Error: ${userSnapshot.error}"));
          } else if (!userSnapshot.hasData) {
            return const Center(child: Text("User not found"));
          } else {
            final user = userSnapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0), // added padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProfilePicture(
                        emojiText: user.profilePicture,
                        size: 50,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Posts",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<PaginatedResponse<Post>>(
                      future: postsFuture,
                      builder: (context, postsSnapshot) {
                        if (postsSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (postsSnapshot.hasError) {
                          return Center(child: Text("Error: ${postsSnapshot.error}"));
                        } else if (!postsSnapshot.hasData || postsSnapshot.data!.data.isEmpty) {
                          return const Center(child: Text("No posts available"));
                        } else {
                          return PaginatedPostsWidget(initialResponse: postsSnapshot.data!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
