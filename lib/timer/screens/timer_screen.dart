import 'package:clock_app/common/types/picker_result.dart';
import 'package:clock_app/timer/screens/customize_timer_screen.dart';
import 'package:clock_app/timer/screens/timer_fullscreen.dart';
import 'package:clock_app/timer/widgets/timer_picker.dart';
import 'package:flutter/material.dart';

import 'package:great_list_view/great_list_view.dart';

import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/timer_card.dart';

typedef TimerCardBuilder = Widget Function(
  BuildContext context,
  int index,
  AnimatedWidgetBuilderData data,
);

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _listController = PersistentListController<ClockTimer>();

  void _handleDeleteTimer(ClockTimer deletedTimer) {
    int index = _listController.getItemIndex(deletedTimer);
    deletedTimer.reset();
    _listController.changeItems((timers) => timers[index] = deletedTimer);
  }

  void _handleToggleState(ClockTimer timer) {
    int index = _listController.getItemIndex(timer);
    timer.toggleState();
    _listController.changeItems((timers) => timers[index] = timer);
  }

  void _handleResetTimer(ClockTimer timer) {
    int index = _listController.getItemIndex(timer);
    timer.reset();
    _listController.changeItems((timers) => timers[index] = timer);
  }

  void _handleAddTimeToTimer(ClockTimer timer) {
    int index = _listController.getItemIndex(timer);
    timer.addTime();
    _listController.changeItems((timers) => timers[index] = timer);
  }

  Future<ClockTimer?> _openCustomizeTimerScreen(ClockTimer timer) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomizeTimerScreen(initialTimer: timer)),
    );
  }

  Future<ClockTimer> _handleCustomizeTimer(ClockTimer timer) async {
    int index = _listController.getItemIndex(timer);
    ClockTimer? newTimer = await _openCustomizeTimerScreen(timer);
    if (newTimer == null) return timer;
    newTimer.reset();
    newTimer.start();

    _listController.changeItems((timers) => timers[index] = newTimer);
    return newTimer;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Expanded(
            child: PersistentListView<ClockTimer>(
              saveTag: 'timers',
              listController: _listController,
              itemBuilder: (timer) => TimerCard(
                key: ValueKey(timer),
                timer: timer,
                onToggleState: () => _handleToggleState(timer),
              ),
              onTapItem: (timer, index) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerFullscreen(
                      timer: timer,
                      onReset: _handleResetTimer,
                      onToggleState: _handleToggleState,
                      onAddTime: _handleAddTimeToTimer,
                      onCustomize: _handleCustomizeTimer,
                    ),
                  ),
                );
                _listController.reload();
                // _listController.changeItems((item) {});
              },
              onDeleteItem: _handleDeleteTimer,
              duplicateItem: (timer) => ClockTimer.from(timer),
              placeholderText: "No timers created",
              reloadOnPop: true,
            ),
          ),
        ],
      ),
      FAB(
        onPressed: () async {
          PickerResult<ClockTimer>? pickerResult =
              await showTimerPicker(context);
          if (pickerResult != null) {
            ClockTimer timer = ClockTimer.from(pickerResult.value);
            if (pickerResult.isCustomize) {
              timer = await _openCustomizeTimerScreen(timer) ?? timer;
            }
            timer.start();
            _listController.addItem(timer);
          }
        },
      )
    ]);
  }
}
