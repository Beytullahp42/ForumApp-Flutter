import 'package:flutter/material.dart';
import 'package:forum_app_ui/pages/create_post_page.dart';
import 'package:forum_app_ui/pages/home_page.dart';
import 'package:forum_app_ui/pages/login_page.dart';
import 'package:forum_app_ui/pages/no_connection_page.dart';
import 'package:forum_app_ui/pages/post_page.dart';
import 'package:forum_app_ui/pages/profile_page.dart';
import 'package:forum_app_ui/pages/register_page.dart';
import 'package:forum_app_ui/pages/settings_page.dart';

class AppRoutes {
  static const String home = "/home";
  static const String login = "/login";
  static const String register = "/register";
  static const String settings = "/settings";
  static const String profile = "/profile";
  static const String createPost = "/createPost";
  static const String post = "/post";
  static const String noConnectionPage = "/noConnectionPage";

  static const String initialRoute = home;

  static Map<String, WidgetBuilder> routes = {
    "/home": (context) => const HomePage(),
    "/login": (context) => const LoginPage(),
    "/register": (context) => const RegisterPage(),
    "/profile": (context) => const ProfilePage(),
    "/settings": (context) => const SettingsPage(),
    "/createPost": (context) => const CreatePostPage(),
    "/post": (context) => const PostPage(),
    "/noConnectionPage": (context) => const NoConnectionPage(),
  };
}
