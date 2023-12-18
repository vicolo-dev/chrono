import 'package:flutter/material.dart';

class NotificationAction {
  final void Function(VoidCallback onDismiss, VoidCallback onSnooze,
      String dismissLabel, String snoozeLabel) builder;

  const NotificationAction({
    required this.builder,
  });
}
