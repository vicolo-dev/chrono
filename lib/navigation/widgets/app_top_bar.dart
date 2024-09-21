import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String? title;
  final List<Widget>? actions;
  final Color? systemNavBarColor;

  @override
  Size get preferredSize => const Size(0, 56);

  const AppTopBar({
    super.key,
    this.titleWidget,
    this.actions,
    this.systemNavBarColor,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // final bool showBackButton = Navigator.of(context).canPop();

    final systemNavigationBarColor =
        systemNavBarColor ?? colorScheme.background;

    Brightness statusBarIconBrightness =
        colorScheme.surface.computeLuminance() > 0.179
            ? Brightness.dark
            : Brightness.light;
    Brightness systemNavBarIconBrightness =
        systemNavigationBarColor.computeLuminance() > 0.179
            ? Brightness.dark
            : Brightness.light;

    Widget? barTitleWidget = titleWidget ??
        (title != null
            ? Text(
                title!,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                ),
              )
            : null);

    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool showBackButton = parentRoute?.impliesAppBarDismissal ?? false;

    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: systemNavBarIconBrightness,
            statusBarColor: colorScheme.background,
            statusBarIconBrightness:
                statusBarIconBrightness, // For Android (dark icons)
          ),
          scrolledUnderElevation: 0,
          toolbarHeight: preferredSize.height,
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackButton) ...[
                IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: colorScheme.onSurface.withOpacity(0.8)),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero),
                const SizedBox(width: 8)
              ],
              if (!showBackButton) const SizedBox(width: 16),
              if (barTitleWidget != null) barTitleWidget,
            ],
          ),
          actions: [...?actions],
          elevation: 0,
          automaticallyImplyLeading: false,
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
