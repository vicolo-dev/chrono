import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class AreaNotificationAction extends StatelessWidget {
  const AreaNotificationAction(
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
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: CardContainer(
                    color: colorScheme.primary,
                    onTap: onDismiss,
                    child: Center(
                        child: Text(
                      dismissLabel,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    )),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (onSnooze != null)
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: CardContainer(
                      color: colorScheme.primary,
                      onTap: onSnooze,
                      child: Center(
                          child: Text(
                        snoozeLabel,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      )),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
