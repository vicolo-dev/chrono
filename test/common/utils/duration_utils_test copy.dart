import 'package:clock_app/common/utils/duration.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter_test/flutter_test.dart';

Duration duration = const Duration(hours: 1, minutes: 30, seconds: 0);

void main() {
  group('DurationUtils', () {
    testWidgets(
      'toTimeDuration() returns correct value',
      (tester) async {
        expect(duration.toTimeDuration(),
            const TimeDuration(hours: 1, minutes: 30));
      },
    );
  });
}
