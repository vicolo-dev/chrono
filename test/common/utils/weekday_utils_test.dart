import 'package:clock_app/common/data/weekdays.dart';
import 'package:clock_app/common/utils/weekday_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('weekdaysContains', () {
    test('returns true when the weekday is contained in the list', () {
      final testWeekdays = [weekdays[0]];
      expect(weekdaysContains(testWeekdays, 'Mon'), isTrue);
    });

    test('returns false when the weekday is not contained in the list', () {
      final testWeekdays = [weekdays[0]];
      expect(weekdaysContains(testWeekdays, 'Tue'), isFalse);
    });
  });

  group('weekdaysContainsAll', () {
    test('returns true when all the weekdays are contained in the list', () {
      final testWeekdays = [weekdays[5], weekdays[6]];
      expect(weekdaysContainsAll(testWeekdays, ['Sat', 'Sun']), isTrue);
    });

    test('returns false when at least one weekday is not contained in the list',
        () {
      final testWeekdays = [weekdays[4], weekdays[6]];
      expect(weekdaysContainsAll(testWeekdays, ['Sat', 'Mon']), isFalse);
    });
  });
}
