import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ButtonsNotificationAction extends StatelessWidget {
  const ButtonsNotificationAction(
      {super.key,
      required this.dismissLabel,
      required this.snoozeLabel,
      required this.onDismiss,
      this.onSnooze});

  final String dismissLabel;
  final String snoozeLabel;
  final VoidCallback onDismiss;
  final VoidCallback? onSnooze;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onSnooze != null)
          CardContainer(
            color: colorScheme.primary,
            onTap: onSnooze,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(snoozeLabel,
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onPrimary)),
            ),
          ),
        CardContainer(
          color: colorScheme.primary,
          onTap: onDismiss,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(dismissLabel,
                style: textTheme.titleMedium
                    ?.copyWith(color: colorScheme.onPrimary)),
          ),
        ),
      ],
    );
  }
}
