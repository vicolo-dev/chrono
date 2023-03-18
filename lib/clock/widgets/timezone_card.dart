import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card_content.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as timezone;

class TimeZoneCard extends StatelessWidget {
  TimeZoneCard({
    Key? key,
    required this.city,
  }) : super(key: key) {
    _timezoneLocation = timezone.getLocation(city.timezone);
    _offset = (_timezoneLocation.currentTimeZone.offset -
            DateTime.now().timeZoneOffset.inMilliseconds) /
        3600000;
  }

  late final timezone.Location _timezoneLocation;
  late final double _offset;
  final City city;

  String _formatTimeOffset(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  String _getOffsetDescription() {
    DateTime currentTime = DateTime.now();
    DateTime cityTime = timezone.TZDateTime.now(_timezoneLocation);

    String hourDifference = _formatTimeOffset(_offset.abs());
    String hourLabel = _offset == 1 ? 'hour' : 'hours';
    String relativeLabel = _offset < 0 ? 'behind' : 'ahead';
    String differentOffsetLabel = '$hourDifference $hourLabel $relativeLabel';
    String offsetLabel = _offset != 0 ? differentOffsetLabel : 'Same time';

    String differentDayLabel = currentTime.day < cityTime.day
        ? ' (next day)'
        : currentTime.day > cityTime.day
            ? ' (previous day)'
            : '';

    return '$offsetLabel$differentDayLabel';
  }

  @override
  Widget build(BuildContext context) {
    return TimezoneCardContent(
      title: city.name,
      subtitle: _getOffsetDescription(),
      timezoneLocation: _timezoneLocation,
    );
  }
}
