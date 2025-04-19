import 'package:flutter/material.dart';
import 'package:forum_app_ui/components/unfocus_wrapper.dart';
import 'package:forum_app_ui/routes.dart';
import 'package:forum_app_ui/services/api_calls.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> with RouteAware {
  @override
  void didPopNext() {
    checkConnection(context);
  }

  @override
  void didPush() {
    checkConnection(context);
  }


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = "Please fill in both email and password.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await ApiCalls.login(email, password);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _error = "Login failed. Please check your credentials.";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusOnTap(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text("Login"),
                    ),
                const SizedBox(height: 10),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.register);
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
