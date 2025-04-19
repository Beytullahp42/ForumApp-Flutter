import 'package:flutter/material.dart';

class UnfocusOnTap extends StatelessWidget {
  final Widget child;

  const UnfocusOnTap({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
