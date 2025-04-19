import 'package:flutter/material.dart';
import 'package:forum_app_ui/components/profile_picture.dart';
import 'package:forum_app_ui/components/unfocus_wrapper.dart';
import 'package:forum_app_ui/routes.dart';
import 'package:forum_app_ui/services/api_calls.dart';

import '../components/change_password_modal.dart';
import '../components/delete_account_modal.dart';
import '../main.dart';
import '../models/user.dart';

class SettingsPage extends StatefulWidget {
  final User user;

  const SettingsPage({super.key, required this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with RouteAware {
  @override
  void didPopNext() {
    checkConnection(context);
  }

  @override
  void didPush() {
    checkConnection(context);
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String emojiText = "&white";
  String? emailError;

  // For password change
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // For delete account
  final TextEditingController _deletePasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    ApiCalls.getUser().then((user) {
      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email;
        emojiText = user.profilePicture;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _deletePasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: () async {
              final success = await ApiCalls.updateProfile(
                _nameController.text,
                _emailController.text,
                "😉&purple",
              );
              if (success && mounted) {
                setState(() {
                  emailError = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile updated successfully!"),
                  ),
                );
              } else if (mounted) {
                setState(() {
                  emailError = "This email is already taken";
                });
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: UnfocusOnTap(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              //How to add a clickable image
              GestureDetector(
                child: ProfilePicture(emojiText: emojiText, size: 150),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  errorText: emailError,
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return const ChangePasswordModal();
                    },
                  );
                },
                child: Text("Change Password"),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  ApiCalls.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text("Logout"),
              ),
              const SizedBox(height: 10),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteAccountModal();
                    },
                  );
                },
                child: Text("Delete Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
