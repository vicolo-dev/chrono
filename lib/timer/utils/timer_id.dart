import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/types/timer.dart';

ClockTimer? getTimerById(id) {
  final List<ClockTimer> timers = loadListSync('timers');
  try {
    return timers.firstWhere((timer) => timer.id == id);
  } catch (e) {
    return null;
  }
}

  Future<ClockTimer> getSmallestTimer()async{
     return (await loadList<ClockTimer>("timers"))
        .where((timer) => timer.isRunning)
        .reduce((a, b) => a.remainingSeconds < b.remainingSeconds ? a : b);
  }


