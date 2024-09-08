import 'package:clock_app/navigation/data/tabs.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

Future<void> initializeQuickActions(
    BuildContext context, Function(int, [String?]) setTab) async {
  const QuickActions quickActions = QuickActions();
  await quickActions.initialize((shortcutType) {
    if (shortcutType == 'action_add_alarm') {
      setTab(getTabs(context).indexWhere((tab) => tab.id == "alarm"), "add_alarm");
    }
    if (shortcutType == 'action_add_timer') {
      setTab(getTabs(context).indexWhere((tab) => tab.id == "timer"), "add_timer");
    }
    // More handling code...
  });

  await quickActions.setShortcutItems(<ShortcutItem>[
    const ShortcutItem(
        type: 'action_add_alarm',
        localizedTitle: 'Add alarm',
        icon: 'alarm_icon'),
    const ShortcutItem(
        type: 'action_add_timer',
        localizedTitle: 'Add timer',
        icon: 'timer_icon')
  ]);
}
