import 'package:clock_app/common/types/json.dart';

class TimeDuration extends JsonSerializable {
  final int hours;
  final int minutes;
  final int seconds;
  final int milliseconds;

  int get inMilliseconds => inSeconds * 1000 + milliseconds;
  int get inSeconds => hours * 3600 + minutes * 60 + seconds;
  int get inMinutes => inSeconds ~/ 60;
  int get inHours => inMinutes ~/ 60;
  static TimeDuration get zero =>
      const TimeDuration(hours: 0, minutes: 0, seconds: 0);

  const TimeDuration({
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.milliseconds = 0,
  });

  TimeDuration.from(TimeDuration other)
      : hours = other.hours,
        minutes = other.minutes,
        seconds = other.seconds,
        milliseconds = other.milliseconds;

  TimeDuration.fromSeconds(int seconds)
      : hours = (seconds / 3600).floor(),
        minutes = ((seconds % 3600) / 60).floor(),
        seconds = (seconds % 3600) % 60,
        milliseconds = 0;

  TimeDuration.fromMilliseconds(int milliseconds)
      : hours = (milliseconds / 3600000).floor(),
        minutes = ((milliseconds % 3600000) / 60000).floor(),
        seconds = ((milliseconds % 3600000) % 60000 / 1000).floor(),
        milliseconds = ((milliseconds % 3600000) % 60000 % 1000).floor();

  Duration get toDuration => Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds);

  TimeDuration add(TimeDuration other) {
    return TimeDuration.fromMilliseconds(inMilliseconds + other.inMilliseconds);
  }

  @override
  String toString() {
    if (inMilliseconds == 0) return "0s";
    String hoursString = hours > 0 ? '${hours}h ' : '';
    String minutesString = minutes > 0 ? '${minutes}m ' : '';
    String secondsString = seconds > 0 ? '${seconds}s' : '';
    String millisecondsString = milliseconds > 0 ? '${milliseconds}ms' : '';
    return "$hoursString$minutesString$secondsString$millisecondsString".trim();
  }

  String toReadableString() {
    if (inMilliseconds == 0) return "0 seconds";
    String hoursString =
        hours > 0 ? '$hours ${hours == 1 ? "hour" : "hours"} ' : '';
    String minutesString =
        minutes > 0 ? '$minutes ${minutes == 1 ? "minute" : "minutes"} ' : '';
    String secondsString =
        seconds > 0 ? '$seconds ${seconds == 1 ? "second" : "seconds"} ' : '';
    String millisecondsString = milliseconds > 0 ? '${milliseconds}ms' : '';
    return "$hoursString$minutesString$secondsString$millisecondsString".trim();
  }

  String toTimeString({bool showMilliseconds = false}) {
    if (inMilliseconds == 0) return "0";
    String twoDigits(int n) => n.toString().padLeft(2, "0").substring(0, 2);
    String hoursString = hours > 0 ? '$hours:' : '';
    String minutesString =
        minutes > 0 ? (hours > 0 ? '${twoDigits(minutes)}:' : '$minutes:') : '';
    String secondsString =
        (hours > 0 || minutes > 0) ? twoDigits(seconds) : '$seconds';
    String millisecondsString =
        showMilliseconds ? '.${twoDigits(milliseconds)}' : '';
    return "$hoursString$minutesString$secondsString$millisecondsString";
  }

  @override
  Json toJson() => {
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
        'milliseconds': milliseconds,
      };

  TimeDuration.fromJson(Json json)
      : hours = json != null ? json['hours'] ?? 0 : 0,
        minutes = json != null ? json['minutes'] ?? 0 : 0,
        seconds = json != null ? json['seconds'] ?? 0 : 0,
        milliseconds = json != null ? json['milliseconds'] ?? 0 : 0;
}
