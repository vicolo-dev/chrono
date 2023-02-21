class TimeDuration {
  int hours;
  int minutes;
  int seconds;

  int get inSeconds => hours * 3600 + minutes * 60 + seconds;
  static TimeDuration get zero =>
      TimeDuration(hours: 0, minutes: 0, seconds: 0);

  TimeDuration(
      {required this.hours, required this.minutes, required this.seconds});

  TimeDuration.fromSeconds(int seconds)
      : hours = (seconds / 3600).floor(),
        minutes = ((seconds % 3600) / 60).floor(),
        seconds = (seconds % 3600) % 60;

  Duration get toDuration =>
      Duration(hours: hours, minutes: minutes, seconds: seconds);

  @override
  String toString() {
    String hoursString = hours > 0 ? '${hours}h ' : '';
    String minutesString = minutes > 0 ? '${minutes}m ' : '';
    String secondsString = seconds > 0 ? '${seconds}s' : '';
    return "$hoursString$minutesString$secondsString";
  }

  String toTimeString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hoursString = hours > 0 ? '$hours:' : '';
    String minutesString =
        minutes > 0 ? (hours > 0 ? '${twoDigits(minutes)}:' : '$minutes:') : '';
    String secondsString =
        (hours > 0 || minutes > 0) ? twoDigits(seconds) : '$seconds';
    return "$hoursString$minutesString$secondsString";
  }
}
