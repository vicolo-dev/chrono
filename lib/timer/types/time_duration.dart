import 'package:clock_app/common/utils/json_serialize.dart';

class TimeDuration extends JsonSerializable {
  int hours;
  int minutes;
  int seconds;
  int milliseconds;

  int get inSeconds => hours * 3600 + minutes * 60 + seconds;
  int get inMilliseconds => inSeconds * 1000 + milliseconds;
  static TimeDuration get zero =>
      TimeDuration(hours: 0, minutes: 0, seconds: 0);

  TimeDuration(
      {required this.hours,
      required this.minutes,
      required this.seconds,
      this.milliseconds = 0});

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

  @override
  String toString() {
    String hoursString = hours > 0 ? '${hours}h ' : '';
    String minutesString = minutes > 0 ? '${minutes}m ' : '';
    String secondsString = seconds > 0 ? '${seconds}s' : '';
    String millisecondsString = milliseconds > 0 ? '${milliseconds}ms' : '';
    return "$hoursString$minutesString$secondsString$millisecondsString";
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
  Map<String, dynamic> toJson() => {
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
        'milliseconds': milliseconds,
      };

  TimeDuration.fromJson(Map<String, dynamic> json)
      : hours = json['hours'],
        minutes = json['minutes'],
        seconds = json['seconds'],
        milliseconds = json['milliseconds'];
}
