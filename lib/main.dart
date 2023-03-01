import 'dart:core';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/alarm/logic/alarm_controls.dart';
import 'package:clock_app/alarm/logic/handle_boot.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/clock/logic/timezone_database.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';
import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/shadow.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot_receiver/flutter_boot_receiver.dart';
import 'package:timezone/data/latest_all.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeTimeZones();
  await initializeAppDataDirectory();
  await initializeSettings();
  await initializeDatabases();
  await AndroidAlarmManager.initialize();
  await RingtoneManager.initialize();
  await RingtonePlayer.initialize();
  await initializeAudioSession();
  await BootReceiver.initialize(handleBoot);
  await initializeNotifications();
  AppVisibility.initialize();
  await LockScreenFlagManager.initialize();

  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(receivePort.sendPort, updatePortName);
  receivePort.listen((message) {
    if (message == "updateAlarms") {
      SettingsManager.notifyListeners("alarms");
    } else if (message == "updateTimers") {
      SettingsManager.notifyListeners("timers");
    }
  });

  String appDataDirectory = await getAppDataDirectoryPath();
  String path = '$appDataDirectory/ringing-alarm.txt';
  File file = File(path);
  if (!file.existsSync()) {
    file.createSync();
  }
  file.writeAsStringSync("", mode: FileMode.writeOnly);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();

  static void setColorScheme(BuildContext context, ColorScheme colorScheme) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setColorScheme(colorScheme);
  }

  static void setAccentColor(BuildContext context, Color color) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setAccentColor(color);
  }

  static void setCardRadius(BuildContext context, double radius) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setCardRadius(radius);
  }

  static void setCardElevation(BuildContext context, double elevation) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setCardElevation(elevation);
  }

  static void setShadowColor(BuildContext context, Color color) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setShadowColor(color);
  }

  static void setShadowOpacity(BuildContext context, double opacity) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setShadowOpacity(opacity);
  }

  static void setShadowBlurRadius(BuildContext context, double radius) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setShadowBlurRadius(radius);
  }
}

class _AppState extends State<App> {
  ThemeData _theme = defaultTheme;

  @override
  void initState() {
    NotificationController.setListeners();
    super.initState();
  }

  setColorScheme(ColorScheme colorScheme) {
    setState(() {
      _theme = _theme.copyWith(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        cardColor: colorScheme.surface,
        dialogBackgroundColor: colorScheme.surface,
        textTheme: _theme.textTheme.apply(
          bodyColor: colorScheme.onBackground,
          displayColor: colorScheme.onBackground,
        ),
        snackBarTheme: _theme.snackBarTheme.copyWith(
          backgroundColor: colorScheme.primary,
          contentTextStyle: _theme.snackBarTheme.contentTextStyle!.apply(
            color: colorScheme.onSurface,
          ),
        ),
        inputDecorationTheme:
            getInputTheme(colorScheme, _theme.toggleButtonsTheme.borderRadius!),
      );
    });
  }

  setAccentColor(Color color) {
    setColorScheme(_theme.colorScheme.copyWith(
      primary: color,
      secondary: color,
    ));
    setShadowColor(appSettings.getSetting("Use Accent Color").value
        ? _theme.colorScheme.primary
        : Colors.black);
  }

  setCardRadius(double radius) {
    setState(() {
      RoundedRectangleBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );
      _theme = _theme.copyWith(
        cardTheme: _theme.cardTheme.copyWith(shape: shape),
        bottomSheetTheme: _theme.bottomSheetTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(radius),
            ),
          ),
        ),
        timePickerTheme: _theme.timePickerTheme.copyWith(
          shape: shape,
          dayPeriodShape: shape,
          hourMinuteShape: shape,
        ),
        toggleButtonsTheme: _theme.toggleButtonsTheme.copyWith(
          borderRadius: BorderRadius.circular(radius),
        ),
        inputDecorationTheme:
            getInputTheme(_theme.colorScheme, BorderRadius.circular(radius)),
      );
    });
  }

  setCardElevation(double elevation) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ShadowStyle>()?.copyWith(
                  elevation: elevation,
                ) ??
            const ShadowStyle(),
      ]);
    });
  }

  setShadowColor(Color color) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ShadowStyle>()?.copyWith(
                  color: color,
                ) ??
            const ShadowStyle(),
      ]);
    });
  }

  setShadowOpacity(double opacity) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ShadowStyle>()?.copyWith(
                  opacity: opacity,
                ) ??
            const ShadowStyle(),
      ]);
    });
  }

  setShadowBlurRadius(double blurRadius) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ShadowStyle>()?.copyWith(
                  blurRadius: blurRadius,
                ) ??
            const ShadowStyle(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Clock',
      theme: _theme,
      initialRoute: Routes.rootRoute,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        Routes.push(settings.name ?? Routes.rootRoute);
        switch (settings.name) {
          case Routes.rootRoute:
            return MaterialPageRoute(builder: (context) => const NavScaffold());

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
