import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ModalAction {
  final String title;
  final VoidCallback? onPressed;

  const ModalAction({required this.title, this.onPressed});
}

class Modal extends StatelessWidget {
  const Modal({
    super.key,
    this.title,
    required this.child,
    this.onSave,
    this.additionalAction,
    this.titleWidget,
    this.isSaveEnabled = true,
  });

  final String? title;
  final Widget child;
  final VoidCallback? onSave;
  final ModalAction? additionalAction;
  final Widget? titleWidget;
  final bool isSaveEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      title: title != null
          ? Text(
              title!,
              style: textTheme.displaySmall?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            )
          : null,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancelButton,
                  style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.6))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (additionalAction != null) ...[
              const Spacer(),
              TextButton(
                onPressed: additionalAction!.onPressed,
                child: Text(
                  additionalAction!.title,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.saveButton,
                style: textTheme.labelMedium?.copyWith(
                  color: isSaveEnabled
                      ? colorScheme.primary
                      : colorScheme.onBackground.withOpacity(0.4),
                ),
              ),
              onPressed: () {
                if (isSaveEnabled) {
                  onSave?.call();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
