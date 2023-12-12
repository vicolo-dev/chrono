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
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorScheme.background,
            statusBarIconBrightness:
                colorScheme.background.computeLuminance() > 0.179
                    ? Brightness.dark
                    : Brightness.light, // For Android (dark icons)
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
