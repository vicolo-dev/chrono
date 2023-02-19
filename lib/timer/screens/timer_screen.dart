import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/timer/widgets/duration_picker.dart';
import 'package:clock_app/timer/widgets/time_input_field.dart';
import 'package:clock_app/timer/widgets/timer_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:great_list_view/great_list_view.dart';

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
  List<Timer> _timers = [];

  final _scrollController = ScrollController();
  final _controller = AnimatedListController();

  int _getTimerIndex(Timer timer) =>
      _timers.indexWhere((element) => element.id == timer.id);

  void loadTimers() {
    setState(() {
      _timers = loadList('timers');
    });

    _controller.notifyChangedRange(
      0,
      _timers.length,
      getChangeWidgetBuilder(),
    );
  }

  @override
  void initState() {
    super.initState();
    _timers = loadList('timers');
  }

  TimerCardBuilder getTimerChangeWidgetBuilder(Timer timer) =>
      (context, index, data) => data.measuring
          ? const SizedBox(width: 64, height: 64)
          : TimerCard(
              key: ValueKey(timer),
              timer: timer,
              onTap: () => {},
              onDelete: () => {},
              onDuplicate: () => {},
            );

  TimerCardBuilder getChangeWidgetBuilder() => (context, index, data) =>
      getTimerChangeWidgetBuilder(_timers[index])(context, index, data);

  bool _handleReorderTimers(int oldIndex, int newIndex, Object? slot) {
    if (newIndex >= _timers.length) return false;
    _timers.insert(newIndex, _timers.removeAt(oldIndex));
    saveList('timers', _timers);
    return true;
  }

  _handleDeleteTimer(Timer deletedTimer) {
    int index = _getTimerIndex(deletedTimer);
    _timers[index].stop();
    _timers.removeAt(index);
    _controller.notifyRemovedRange(
      index,
      1,
      getTimerChangeWidgetBuilder(deletedTimer),
    );
    saveList('timers', _timers);
  }

  _handleAddTimer(Timer timer, {int index = -1}) {
    if (index == -1) index = _timers.length;
    // timer.schedule();
    _timers.insert(index, timer);
    _controller.notifyInsertedRange(index, 1);

    saveList('timers', _timers);
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
          child: SlidableAutoCloseBehavior(
            child: AutomaticAnimatedListView<Timer>(
              list: _timers,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              comparator: AnimatedListDiffListComparator<Timer>(
                sameItem: (a, b) => a.id == b.id,
                sameContent: (a, b) => a.id == b.id,
              ),
              itemBuilder: (BuildContext context, Timer timer, data) {
                return data.measuring
                    ? const SizedBox(width: 64, height: 64)
                    : TimerCard(
                        key: ValueKey(timer),
                        timer: timer,
                        onTap: () => {},
                        onDelete: () => _handleDeleteTimer(timer),
                        onDuplicate: () => _handleAddTimer(
                            Timer.fromTimer(timer),
                            index: _getTimerIndex(timer) + 1),
                      );
              },
              // animator: DefaultAnimatedListAnimator,
              listController: _controller,
              scrollController: _scrollController,
              addLongPressReorderable: true,
              reorderModel: AnimatedListReorderModel(
                onReorderStart: (index, dx, dy) => true,
                onReorderFeedback: (int index, int dropIndex, double offset,
                        double dx, double dy) =>
                    null,
                onReorderMove: (int index, int dropIndex) => true,
                onReorderComplete: _handleReorderTimers,
              ),
              reorderDecorationBuilder: reorderableListDecorator,
              footer: const SizedBox(height: 64),
            ),
          ),
        ),
      ]),
      FAB(
        onPressed: () async {
          TimeDuration? timeDuration = await showDurationPicker(context);
          if (timeDuration == null) return;
          Timer timer = Timer(timeDuration);
          timer.start();
          _handleAddTimer(timer);
        },
      )
    ]);
  }
}
