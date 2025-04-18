import 'package:flutter/material.dart';
import 'package:forum_app_ui/routes.dart';

Widget commentTile(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Text("Content", style: TextStyle(fontSize: 20)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_up)),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_down),
                ),
              ],
            ),
          ],
        ),
      ),
      const Divider(color: Colors.grey, height: 1),
    ],
  );
}
