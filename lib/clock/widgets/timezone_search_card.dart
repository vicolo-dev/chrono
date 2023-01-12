import 'package:clock_app/clock/widgets/timzone_card_content.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart' as timezone;

import 'package:clock_app/clock/types/city.dart';

class TimeZoneSearchCard extends StatelessWidget {
  TimeZoneSearchCard(
      {Key? key,
      required this.city,
      required this.onTap,
      this.disabled = false})
      : super(key: key) {
    timezoneLocation = timezone.getLocation(city.timezone);
  }

  final bool disabled;
  late final timezone.Location timezoneLocation;
  final City city;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          surfaceTintColor: disabled ? Colors.pink : null,
          elevation: disabled ? 1 : 2,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              if (disabled) {
                const snackBar = SnackBar(
                  content: Text('This city is already in your favorites.'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                onTap();
              }
            },
            child: TimezoneCardContent(
              title: city.name,
              subtitle: city.country,
              timezoneLocation: timezoneLocation,
              textColor: disabled ? ColorTheme.textColorTertiary : null,
            ),
          )),
    );
  }
}
