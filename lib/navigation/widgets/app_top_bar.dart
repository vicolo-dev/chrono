import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Color? systemNavBarColor;

  @override
  Size get preferredSize => const Size(0, 56);

  const AppTopBar({
    super.key,
    this.title,
    this.actions, this.systemNavBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final systemNavigationBarColor = systemNavBarColor ?? colorScheme.background;

    Brightness statusBarIconBrightness =
        colorScheme.surface.computeLuminance() > 0.179
            ? Brightness.dark
            : Brightness.light;
    Brightness systemNavBarIconBrightness =
        systemNavigationBarColor.computeLuminance() > 0.179
            ? Brightness.dark
            : Brightness.light;

    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: systemNavBarIconBrightness,
            statusBarColor: colorScheme.surface,
            statusBarIconBrightness:
                statusBarIconBrightness, // For Android (dark icons)
          ),
          scrolledUnderElevation: 0,
          toolbarHeight: preferredSize.height,
          title: title,
          actions: [...?actions],
          elevation: 0,
          iconTheme: IconThemeData(
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
          titleTextStyle: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
