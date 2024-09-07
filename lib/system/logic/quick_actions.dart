import 'package:quick_actions/quick_actions.dart';

Future<void> initializeQuickActions ( Function(int) setTab)  async {
  const QuickActions quickActions = QuickActions();
  await quickActions.initialize((shortcutType) {
    if (shortcutType == 'action_add_alarm') {
      setTab(0);
    }
    if (shortcutType == 'action_add_timer') {
      setTab(1);
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
