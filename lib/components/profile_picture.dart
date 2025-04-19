import 'package:flutter/material.dart';
import 'package:forum_app_ui/components/color_option.dart';

class ProfilePicture extends StatelessWidget {
  final String emojiText; // The emoji to display
  final double size; // The size of the profile picture (circle and emoji)

  const ProfilePicture({
    super.key,
    required this.emojiText,
    this.size = 50.0, // Default size is 50.0
  });

  @override
  Widget build(BuildContext context) {
    List<String> parts = emojiText.split('&');
    String emoji = parts[0];
    Color color = ColorOption.getColorByName(parts[1]);
    return Container(
      width: size, // Circle size
      height: size, // Circle size
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color, // You can customize the background color
      ),
      child: Center(
        child: Text(
          emoji, // The emoji inside the circle
          style: TextStyle(
            fontSize: size / 1.625, // Font size based on the circle size
            color: color, // Emoji color
          ),
        ),
      ),
    );
  }

}
