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
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Dismiss"),
          ),
        ),
        CardContainer(
          onTap: onDismiss,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Snooze"),
          ),
        )
      ],
    );
  }
}
