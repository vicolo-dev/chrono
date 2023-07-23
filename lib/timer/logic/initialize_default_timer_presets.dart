import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/timer/data/default_timer_presets.dart';

void initializeDefaultTimerPresets() {
  saveList('timer_presets', defaultTimerPresets);
}
