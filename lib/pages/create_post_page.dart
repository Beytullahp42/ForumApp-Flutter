import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forum_app_ui/components/unfocus_wrapper.dart';

import '../components/color_option.dart';
import '../main.dart';
import '../services/api_calls.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> with RouteAware {
  @override
  void didPopNext() {
    checkConnection(context);
  }

  @override
  void didPush() {
    checkConnection(context);
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  ColorOption _selectedColor = ColorOption.availableColors[0]; // Default: White
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleCreatePost() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all the blanks",
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await ApiCalls.createPost(
      title,
      content,
      _selectedColor.name,
    );

    if (success) {
      Fluttertoast.showToast(
        msg: "Post Created Successfully",
        gravity: ToastGravity.BOTTOM,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: "Failed to create post. Please try again.",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: UnfocusOnTap(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return selectColor(context);
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(_selectedColor.color),
                ),
                child: const Text("Select Color", style: TextStyle(color: Colors.black)),
              ),
              const Spacer(),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _handleCreatePost,
                child: const Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectColor(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Select Color"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: ColorOption.availableColors.map((colorOption) {
                return _colorButton(colorOption);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(ColorOption colorOption) {
    return FilledButton(
      onPressed: () {
        setState(() {
          _selectedColor = colorOption;
        });
        Navigator.pop(context);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(colorOption.color),
      ),
      child: Text(colorOption.name, style: const TextStyle(color: Colors.black)),
    );
  }
}
