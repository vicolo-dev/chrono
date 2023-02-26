import 'package:flutter/material.dart';

import 'package:great_list_view/great_list_view.dart';

import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/persistent_list_view.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/duration_picker.dart';
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
  final _listController = ListController<ClockTimer>();

  void _handleDeleteTimer(ClockTimer deletedTimer) {
    int index = _listController.getItemIndex(deletedTimer);
    _listController.changeItems((timers) {
      timers[index].reset();
    });
  }

  void _handleToggleState(ClockTimer timer) {
    int index = _listController.getItemIndex(timer);
    _listController.changeItems((timers) {
      timers[index].toggleState();
    });
  }

  // Future<Timer?> _openCustomizeTimerScreen(Timer timer) async {
  //   ScaffoldMessenger.of(context).removeCurrentSnackBar();

  //   return await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => CustomizeTimerScreen(initialTimer: timer)),
  //   );
  // }

  // _handleCustomizeTimer(Timer timer) async {
  //   int index = _getTimerIndex(timer);
  //   Timer? newTimer = await _openCustomizeTimerScreen(timer);

  //   if (newTimer == null) return;

  //   newTimer.schedule();
  //   _timers[index] = newTimer;
  //   _controller.notifyChangedRange(
  //     index,
  //     1,
  //     getTimerChangeWidgetBuilder(timer),
  //   );

  //   _showNextScheduleSnackBar(newTimer);

  //   saveList('timers', _timers);
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Expanded(
          child: PersistentListView<ClockTimer>(
            saveTag: 'timers',
            listController: _listController,
            itemBuilder: (timer) => TimerCard(
              key: ValueKey(timer),
              timer: timer,
              onToggleState: () => _handleToggleState(timer),
            ),
            onDeleteItem: _handleDeleteTimer,
            duplicateItem: (alarm) => ClockTimer.fromTimer(alarm),
            placeholderText: "No timers created",
            reloadOnPop: true,
          ),
        ),
      ]),
      FAB(
        onPressed: () async {
          TimeDuration? timeDuration = await showDurationPicker(context);
          if (timeDuration == null) return;
          ClockTimer timer = ClockTimer(timeDuration);
          timer.start();
          _listController.addItem(timer);
        },
      )
    ]);
  }
}
