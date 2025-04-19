import 'dart:convert';

import 'package:forum_app_ui/models/post.dart';
import 'package:forum_app_ui/models/user.dart';
import 'package:forum_app_ui/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment.dart';
import '../models/paginated_response.dart';

class ApiCalls {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return false;
    }
    final response = await HttpService.get("user");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    final body = {"email": email, "password": password};
    final response = await HttpService.post("login", body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      final token = data['token'];
      await prefs.setString('token', token);
      final user = await getUser();
      await prefs.setString('userId', user.id.toString());
      return true;
    } else {
      return false;
    }
  }

  static Future<String> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final body = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
    final response = await HttpService.post("register", body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      final token = data['token'];
      await prefs.setString('token', token);
      final user = await getUser();
      await prefs.setString('userId', user.id.toString());
      return "success";
    } else {
      final data = jsonDecode(response.body);
      return data['message'];
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await HttpService.post("logout", null);
  }

  static Future<bool> deleteAccount(String password) async {
    final response = await HttpService.delete(
      "user",
      body: {"password": password},
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userId');
      return true;
    }
    return false;
  }

  static Future<String> updateProfile(
    String name,
    String email,
    String profilePicture,
  ) async {
    final body = {
      "name": name,
      "email": email,
      "profile_picture": profilePicture,
    };
    final response = await HttpService.put("user", body);
    if (response.statusCode == 200) {
      return "success";
    } else {
      final data = jsonDecode(response.body);
      return data['message'];
    }
  }

  static Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    final body = {
      "old_password": oldPassword,
      "password": newPassword,
      "password_confirmation": newPasswordConfirmation,
    };
    final response = await HttpService.put("user/change-password", body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //the only reason is the wrong password, we are making new password confirmation in the UI
    }
  }

  static Future<User> getUser() async {
    final response = await HttpService.get("user");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data["user"]);
    } else {
      throw Exception("Failed to load user");
    }
  }

  static Future<PaginatedResponse<Post>> getUserPosts({int page = 1}) async {
    final response = await HttpService.get("get-user-posts?page=$page");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse<Post>.fromJson(
        data,
        (json) => Post.fromJson(json),
      );
    } else {
      throw Exception("Failed to load user posts");
    }
  }

  static Future<PaginatedResponse<Post>> getPosts({int page = 1}) async {
    final response = await HttpService.get("posts?page=$page");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse<Post>.fromJson(
        data,
        (json) => Post.fromJson(json),
      );
    } else {
      throw Exception("Failed to load posts");
    }
  }

  static Future<bool> createPost(
    String title,
    String content,
    String? color,
  ) async {
    final body = {
      "title": title,
      "p_content": content,
      "color": color ?? "white",
    };

    final response = await HttpService.post("posts", body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> likePost(int postId) async {
    final response = await HttpService.post("posts/$postId/like", null);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> dislikePost(int postId) async {
    final response = await HttpService.post("posts/$postId/dislike", null);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Post> getPost(int postId) async {
    final response = await HttpService.get("posts/$postId");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception("Failed to load post");
    }
  }

  static Future<void> deletePost(int postId) async {
    final response = await HttpService.delete("posts/$postId");
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to delete post");
    }
  }

  static Future<bool> createComment(
    int postId,
    String content,
  ) async {
    final body = {
      "p_content": content,
    };
    final response = await HttpService.post("posts/$postId/comments", body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<PaginatedResponse<Comment>> getComments(
    int postId, {
    int page = 1,
  }) async {
    final response = await HttpService.get("posts/$postId/comments?page=$page");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedResponse<Comment>.fromJson(
        data,
        (json) => Comment.fromJson(json),
      );
    } else {
      throw Exception("Failed to load comments");
    }
  }

  static Future<bool> likeComment(int commentId) async {
    final response = await HttpService.post("comments/$commentId/like", null);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> dislikeComment(int commentId) async {
    final response = await HttpService.post("comments/$commentId/dislike", null);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteComment(int commentId) async {
    final response = await HttpService.delete("comments/$commentId");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
