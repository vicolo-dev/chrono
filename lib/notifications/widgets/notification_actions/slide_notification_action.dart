import 'package:clock_app/common/widgets/slidable_action.dart';
import 'package:flutter/material.dart';

class SlideNotificationAction extends StatelessWidget {
  const SlideNotificationAction(
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
    return SlideAction(
      leftText: onSnooze != null ? snoozeLabel : null,
      rightText: dismissLabel,
      onSubmitRight: onDismiss,
      onSubmitLeft: onSnooze,
    );
  }
}
