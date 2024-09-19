import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/id.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Log extends ListItem {
  @override
  final int id;
  late String message;
  late DateTime dateTime;
  late Level level;

  Log(
    this.id,
    this.message,
    this.dateTime,
    this.level,
  );

  Log.fromLine(String line, int index) : id = index {
    final regex = RegExp(
        r'\[(\d+-\d+-\d+)\s\|\s(\d+:\d+:\d+)\]\s\[(\w+)\]\s(.*)',
        dotAll: true);
    final match = regex.firstMatch(line);

    if (match != null) {
      final datePart = match.group(1)!;
      final timePart = match.group(2)!;
      level = Level.values.byName(match.group(3)!);
      message = match.group(4)!;

      final dateTimeStr = '$datePart $timePart';
      final dateFormat = DateFormat('d-M-yyyy HH:mm:ss');
      dateTime = dateFormat.parse(dateTimeStr);
    } else {
      message = "Cannot read log";
      level = Level.off;
      dateTime = DateTime.now();
      throw const FormatException('Invalid log format');
    }
  }

  @override
  copy() {
    return Log(id,message, dateTime, level);
  }

  @override
  void copyFrom(other) {
    message = other.message;
    dateTime = other.timestamp;
    level = other.level;
  }

  @override
  bool get isDeletable => false;

  @override
  Json? toJson() {
    return {
      "id": id,
      "message": message,
      "timestamp": dateTime.toIso8601String(),
      "level": level.toString(),
    };
  }
}
