import 'package:flutter/material.dart';
import 'package:forum_app_ui/models/post.dart';
import 'package:forum_app_ui/routes.dart';
import 'package:forum_app_ui/services/api_calls.dart';

import '../components/paginated_posts_view.dart';
import '../main.dart';
import '../models/paginated_response.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late Future<bool> isLoggedIn;
  late Future<PaginatedResponse<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = ApiCalls.getPosts();
    isLoggedIn = ApiCalls.isLoggedIn();
    _checkLogin();
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
    postsFuture = ApiCalls.getPosts();
  }

  @override
  void didPush() {
    checkConnection(context);
  }

  Future<void> _checkLogin() async {
    final loggedIn = await isLoggedIn;
    if (!loggedIn && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Forum App'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createPost);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
              child: FutureBuilder<PaginatedResponse<Post>>(
                future: postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          postsFuture = ApiCalls.getPosts();
                        });
                      },
                      child: PaginatedPostsWidget(
                        initialResponse: snapshot.data!,
                      ),
                    );
                  } else {
                    return const Center(child: Text('Failed to load posts.'));
                  }
                },
              ),
            ),
          );
        } else {
          return const Scaffold(); // fallback
        }
      },
    );
  }
}
