import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class ButtonsNotificationAction extends StatelessWidget {
  const ButtonsNotificationAction(
      {Key? key, required this.onDismiss, required this.onSnooze})
      : super(key: key);

  final VoidCallback onDismiss;
  final VoidCallback onSnooze;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CardContainer(
          onTap: onDismiss,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child:
                Text("Snooze", style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        CardContainer(
          onTap: onDismiss,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child:
                Text("Dismiss", style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ],
    );
  }
}
