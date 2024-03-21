import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:clock_app/alarm/logic/new_alarm_snackbar.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/common/data/app_info.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/onboarding/screens/onboarding_screen.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/listener_manager.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/theme/utils/style_theme.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:receive_intent/receive_intent.dart' as intent_handler;

import 'alarm/logic/alarm_controls.dart';

class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();

  static void setColorScheme(BuildContext context,
      [ColorSchemeData? colorScheme]) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setColorScheme(colorScheme);
  }

  static void setStyleTheme(BuildContext context, StyleTheme styleTheme) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setStyleTheme(styleTheme);
  }

  static void refreshTheme(BuildContext context) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.refreshTheme();
  }
}

class _AppState extends State<App> {
  ThemeData _theme = defaultTheme;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  late SettingGroup _appearanceSettings;
  late SettingGroup _colorSettings;
  late SettingGroup _styleSettings;

  late StreamSubscription _sub;

  void handleIntent(intent_handler.Intent? receivedIntent) async {
    if (receivedIntent != null) {
      print(
          "Intent received ${receivedIntent.action} ${receivedIntent.data} ${receivedIntent.extra}");
      switch (receivedIntent.action) {
        case "android.intent.action.SET_ALARM":
          print("Set alarm");
          int? hour = receivedIntent.extra?["android.intent.extra.alarm.HOUR"];
          int? minute =
              receivedIntent.extra?["android.intent.extra.alarm.MINUTES"];
          bool skipUi =
              receivedIntent.extra?["android.intent.extra.alarm.SKIP_UI"] ??
                  false;
          bool? vibration =
              receivedIntent.extra?["android.intent.extra.alarm.VIBRATE"];
          String? message =
              receivedIntent.extra?["android.intent.extra.alarm.MESSAGE"];
          // string ringtone = receivedIntent.extra?["android.intent.extra.alarm.RINGTONE"];
          List<int>? days =
              receivedIntent.extra?["android.intent.extra.alarm.DAYS"];
          if (hour == null || minute == null || !skipUi) {
            print("Navigate to alarm screen");
            // navigate to alarm screen and open ui
          } else {
            Alarm alarm =
                Alarm.fromTimeOfDay(TimeOfDay(hour: hour, minute: minute));
            if (vibration != null) {
              alarm.setSetting(context, "Vibrate", vibration);
            }
            if (days != null) {
              // In our system, Monday is 1, Sunday is 7
              // In Android, Sunday is 1, Saturday is 7
              // Rotate the days to match our system
              for (int i = 0; i < days.length; i++) {
                days[i] = (days[i] + 1) % 7;
                if (days[i] == 0) days[i] = 7;
              }

              // The setting accepts a list of bools where Monday is index 0
              List<bool> settingDays = List.filled(7, false);
              for (int day in days) {
                settingDays[day - 1] = true;
              }
              alarm.setSetting(context, "Type", WeeklyAlarmSchedule);
              alarm.setSetting(context, "Week Days", settingDays);
            }
            if (message != null) {
              alarm.setSetting(context, "Label", message);
            }

            alarm.update();
            List<Alarm> alarms = await loadList<Alarm>("alarms");
            alarms.add(alarm);
            await saveList("alarms", alarms);
            _showNextScheduleSnackBar(alarm);

            // Update the frontend UI if app is open
            ListenerManager.notifyListeners("alarms-reload");
            // setState(() {});
          }
          break;
        case "android.intent.action.SET_TIMER":
          break;
        case "android.intent.action.SET_STOPWATCH":
          break;
        case "android.intent.action.VIEW_ALARMS":
          break;
        case "android.intent.action.VIEW_TIMERS":
          break;
        default:
          break;
      }
    }
  }

  _showNextScheduleSnackBar(Alarm alarm) {
    Future.delayed(Duration.zero).then((value) {
      _messangerKey.currentState?.removeCurrentSnackBar();
      DateTime? nextScheduleDateTime = alarm.currentScheduleDateTime;
      if (nextScheduleDateTime == null) return;
      _messangerKey.currentState?.showSnackBar(
          getSnackbar(getNewAlarmSnackbarText(alarm), fab: true, navBar: true));
    });
  }

  Future<void> initReceiveIntent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final receivedIntent =
          await intent_handler.ReceiveIntent.getInitialIntent();
      handleIntent(receivedIntent);
    } on PlatformException {
      // Handle exception
    }

    _sub = intent_handler.ReceiveIntent.receivedIntentStream.listen(
        (intent_handler.Intent? receivedIntent) {
      if (receivedIntent != null) {
        handleIntent(receivedIntent);
      }
      // Validate receivedIntent and warn the user, if it is not correct,
    }, onError: (err) {
      // Handle exception
    });
  }

  @override
  void initState() {
    super.initState();
    initReceiveIntent();

    NotificationController.setListeners();

    _appearanceSettings = appSettings.getGroup("Appearance");
    _colorSettings = _appearanceSettings.getGroup("Colors");
    _styleSettings = _appearanceSettings.getGroup("Style");

    setColorScheme(_colorSettings.getSetting("Color Scheme").value);
    setStyleTheme(_styleSettings.getSetting("Style Theme").value);
  }

  refreshTheme() {
    setColorScheme(_colorSettings.getSetting("Color Scheme").value);
    setStyleTheme(_styleSettings.getSetting("Style Theme").value);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  setColorScheme(ColorSchemeData? colorSchemeDataParam) {
    ColorSchemeData colorSchemeData =
        colorSchemeDataParam ?? _colorSettings.getSetting("Color Scheme").value;
    colorSchemeData = colorSchemeData.copy();
    bool shouldOverrideAccent =
        _colorSettings.getSetting("Override Accent Color").value;
    Color overrideColor = _colorSettings.getSetting("Accent Color").value;
    if (shouldOverrideAccent) colorSchemeData.accent = overrideColor;
    setState(() {
      _theme = getThemeFromColorScheme(_theme, colorSchemeData);
    });
  }

  setStyleTheme(StyleTheme? styleThemeParam) {
    StyleTheme styleTheme =
        styleThemeParam ?? _styleSettings.getSetting("Style Theme").value;
    styleTheme = styleTheme.copy();
    setState(() {
      _theme = getThemeFromStyleTheme(_theme, styleTheme);
    });
  }

  // final ThemeData theme = ThemeData(
  //   colorSchemeSeed: Colors.indigo,
  //   textTheme: textTheme,
  // );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      navigatorKey: App.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: getAppName(),
      theme: _theme,
      initialRoute: Routes.rootRoute,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        Routes.push(settings.name ?? Routes.rootRoute);
        switch (settings.name) {
          case Routes.rootRoute:
            final bool? onboarded = GetStorage().read('onboarded');
            if (onboarded == null) {
              return MaterialPageRoute(
                  builder: (context) => const OnBoardingScreen());
            } else {
              return MaterialPageRoute(
                  builder: (context) => const NavScaffold());
            }

          case Routes.alarmNotificationRoute:
            return MaterialPageRoute(
              builder: (context) {
                final List<int> scheduleIds = settings.arguments as List<int>;
                return AlarmNotificationScreen(scheduleId: scheduleIds[0]);
              },
            );

          case Routes.timerNotificationRoute:
            return MaterialPageRoute(
              builder: (context) {
                final List<int> scheduleIds = settings.arguments as List<int>;
                return TimerNotificationScreen(scheduleIds: scheduleIds);
              },
            );

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
    );
  }
}
