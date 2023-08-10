import 'package:flutter/material.dart';

class NotificationAction {
  final void Function(VoidCallback onDismiss, VoidCallback onSnooze) builder;

  const NotificationAction({
    required this.builder,
  });
}
