import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card_content.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as timezone;

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
      child: CardContainer(
        elevationMultiplier: disabled ? 0.5 : 1,
        onTap: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          if (disabled) {
            showSnackBar(context, 'This city is already in your favorites.');
          } else {
            onTap();
          }
        },
        child: TimezoneCardContent(
          title: city.name,
          subtitle: city.country,
          timezoneLocation: timezoneLocation,
          textColor: disabled
              ? Theme.of(context).colorScheme.onBackground.withOpacity(0.6)
              : null,
        ),
      ),
    );
  }
}
