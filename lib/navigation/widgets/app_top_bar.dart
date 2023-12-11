import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size(0, 56);

  const AppTopBar({
    super.key,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return PreferredSize(
      // You can set the size here, but it's left to zeros in order to expand based on its child.
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: colorScheme.background,
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          scrolledUnderElevation: 0,
          toolbarHeight: preferredSize.height,
          title: title,
          actions: [...?actions],
          elevation: 0,
          iconTheme: IconThemeData(
            color: colorScheme.onBackground.withOpacity(0.8),
          ),
          titleTextStyle: textTheme.titleMedium?.copyWith(
            color: colorScheme.onBackground,
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
