import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ButtonsNotificationAction extends StatelessWidget {
  const ButtonsNotificationAction(
      {Key? key,
      required this.dismissLabel,
      required this.snoozeLabel,
      required this.onDismiss,
      this.onSnooze})
      : super(key: key);

  final String dismissLabel;
  final String snoozeLabel;
  final VoidCallback onDismiss;
  final VoidCallback? onSnooze;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onSnooze != null)
          CardContainer(
            onTap: onSnooze,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(snoozeLabel,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        CardContainer(
          onTap: onDismiss,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(dismissLabel,
                style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ],
    );
  }
}
