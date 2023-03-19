import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter_test/flutter_test.dart';

Duration duration = const Duration(hours: 1, minutes: 30);

void main() {
  group('DurationUtils', () {
    test(
      'toTimeDuration() returns correct value',
      () {
        expect(duration.toTimeDuration().inMilliseconds,
            const TimeDuration(hours: 1, minutes: 30).inMilliseconds);
      },
    );
  });
}
