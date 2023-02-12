import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size(0, 56);

  const TopBar({
    super.key,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      // You can set the size here, but it's left to zeros in order to expand based on its child.
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: AppBar(
          toolbarHeight: preferredSize.height,
          title: title,
          actions: actions,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
