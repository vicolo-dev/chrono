import 'package:flutter/material.dart';

class ModalAction {
  final String title;
  final VoidCallback? onPressed;

  const ModalAction({required this.title, this.onPressed});
}

class Modal extends StatelessWidget {
  const Modal({
    Key? key,
    required this.title,
    required this.child,
    this.onSave,
    this.additionalAction,
  }) : super(key: key);

  final String title;
  final Widget child;
  final VoidCallback? onSave;
  final ModalAction? additionalAction;

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
      title: Text(
        title,
        style: textTheme.displaySmall?.copyWith(
          color: colorScheme.onBackground.withOpacity(0.6),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text('Cancel',
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
                'Save',
                style:
                    textTheme.labelMedium?.copyWith(color: colorScheme.primary),
              ),
              onPressed: () {
                onSave?.call();
              },
            ),
          ],
        ),
      ],
    );
  }
}
