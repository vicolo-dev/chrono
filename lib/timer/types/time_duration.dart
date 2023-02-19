class TimeDuration {
  int hours;
  int minutes;
  int seconds;

  int get inSeconds => hours * 3600 + minutes * 60 + seconds;

  TimeDuration(
      {required this.hours, required this.minutes, required this.seconds});

  TimeDuration.fromSeconds(int seconds)
      : hours = (seconds / 3600).floor(),
        minutes = ((seconds % 3600) / 60).floor(),
        seconds = (seconds % 3600) % 60;

  @override
  String toString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(minutes);
    String twoDigitSeconds = twoDigits(seconds);
    return "${hours > 0 ? '${twoDigits(hours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
  }
}
