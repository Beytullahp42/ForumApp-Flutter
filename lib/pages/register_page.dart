import 'package:flutter/material.dart';
import 'package:forum_app_ui/components/unfocus_wrapper.dart';
import 'package:forum_app_ui/routes.dart';
import 'package:forum_app_ui/services/api_calls.dart';

import '../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with RouteAware {
  @override
  void didPopNext() {
    checkConnection(context);
  }

  @override
  void didPush() {
    checkConnection(context);
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // UI validations
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _error = "Please fill in all fields.";
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = "Passwords do not match.";
        _isLoading = false;
      });
      return;
    }
    if (password.length < 8) {
      setState(() {
        _error = "Password must be at least 8 characters long.";
        _isLoading = false;
      });
      return;
    }
    final success = await ApiCalls.register(name, email, password, confirmPassword);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (success == "success") {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _error = success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusOnTap(
        child: Center(
          child: Padding( // helps on small screens / keyboard up
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Register", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
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
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text("Register"),
                ),
                const SizedBox(height: 10),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
