extension DateTimeUtils on DateTime {
  toHours() => hour + minute / 60.0;
}
