// import 'package:clock_app/alarm/types/alarm.dart';
// import 'package:clock_app/theme/shape.dart';
// import 'package:flutter/material.dart';

// showNextScheduleSnackBar(Alarm alarm, BuildContext context) {
//   Future.delayed(Duration.zero).then((value) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     Duration etaNextAlarm =
//         alarm.nextScheduleDateTime.difference(DateTime.now().toLocal());

//     int hours = etaNextAlarm.inHours;
//     int minutes = etaNextAlarm.inMinutes % 60;

//     String hourTextSuffix = hours <= 1 ? "hour" : "hours";
//     String minuteTextSuffix = minutes % 60 <= 1 ? "minute" : "minutes";

//     String hoursText = hours == 0 ? "" : "$hours $hourTextSuffix and ";
//     String minutesText = minutes == 0
//         ? "in less than 1 minute"
//         : "$minutes $minuteTextSuffix from now";

//     SnackBar snackBar = SnackBar(
//       content: Container(
//           alignment: Alignment.centerLeft,
//           height: 28,
//           child: Text('Alarm will ring $hoursText$minutesText')),
//       margin: const EdgeInsets.only(left: 20, right: 64 + 16, bottom: 4),
//       shape: defaultShape,
//       elevation: 2,
//       // padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       dismissDirection: DismissDirection.none,
//       // width: MediaQuery.of(context).size.width - (64 + 16),
//       // behavior: SnackBarBehavior.floating,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   });
// }
