import 'package:clock_app/common/widgets/slidable_action.dart';
import 'package:flutter/material.dart';

class SlideNotificationAction extends StatelessWidget {
  const SlideNotificationAction(
      {Key? key, required this.onDismiss, required this.onSnooze})
      : super(key: key);

  final VoidCallback onDismiss;
  final VoidCallback onSnooze;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      onSubmitRight: onDismiss,
      onSubmitLeft: onSnooze,
    );
  }
}
