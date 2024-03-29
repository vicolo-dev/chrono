import 'dart:async';

import 'package:clock_app/alarm/logic/new_alarm_snackbar.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/common/data/app_info.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/onboarding/screens/onboarding_screen.dart';
import 'package:clock_app/settings/data/appearance_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/system/logic/handle_intents.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:receive_intent/receive_intent.dart' as intent_handler;

class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();

  static void refreshTheme(BuildContext context) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.refreshTheme();
  }
}

class AppTheme {
  ThemeData lightTheme;
  ThemeData darkTheme;

  AppTheme({required this.lightTheme, required this.darkTheme});
}

class _AppState extends State<App> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  late SettingGroup _appearanceSettings;
  late SettingGroup _colorSettings;
  late SettingGroup _styleSettings;

  late StreamSubscription _sub;

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
      if (mounted) {
        handleIntent(receivedIntent, context, _showNextScheduleSnackBar);
      }
    } on PlatformException {
      // Handle exception
    }

    _sub = intent_handler.ReceiveIntent.receivedIntentStream.listen(
        (intent_handler.Intent? receivedIntent) {
      if (receivedIntent != null) {
        handleIntent(receivedIntent, context, _showNextScheduleSnackBar);
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

  }

  refreshTheme() {
    setState(() {});
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  AppTheme getAppTheme(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    ThemeData lightTheme = defaultTheme;
    ThemeData darkTheme = defaultTheme;

    bool useMaterialYou = _colorSettings.getSetting("Use Material You").value;
    bool shouldOverrideAccent =
        _colorSettings.getSetting("Override Accent Color").value;
    Color overrideColor = _colorSettings.getSetting("Accent Color").value;
    StyleTheme styleTheme =
        _styleSettings.getSetting("Style Theme").value.copy();

    if (useMaterialYou) {
      ColorScheme applightColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue, brightness: Brightness.light);
      ColorScheme appDarkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue, brightness: Brightness.dark);

      if (shouldOverrideAccent) {
        applightColorScheme = ColorScheme.fromSeed(
            seedColor: overrideColor, brightness: Brightness.light);
        appDarkColorScheme = ColorScheme.fromSeed(
            seedColor: overrideColor, brightness: Brightness.dark);
      } else {
        if (lightDynamic != null) {
          applightColorScheme = lightDynamic;
        }
        if (darkDynamic != null) {
          appDarkColorScheme = darkDynamic;
        }
      }
      lightTheme =
          getTheme(colorScheme: applightColorScheme, styleTheme: styleTheme);
      darkTheme =
          getTheme(colorScheme: appDarkColorScheme, styleTheme: styleTheme);
      return AppTheme(lightTheme: lightTheme, darkTheme: darkTheme);
    } else {
      ColorSchemeData colorSchemeData =
          _colorSettings.getSetting("Color Scheme").value.copy();
      ColorSchemeData darkColorSchemeData =
          _colorSettings.getSetting("Dark Color Scheme").value.copy();

      if (shouldOverrideAccent) {
        colorSchemeData.accent = overrideColor;
        darkColorSchemeData.accent = overrideColor;
      }
      bool systemDarkMode = _colorSettings.getSetting("System Dark Mode").value;
      if (!systemDarkMode) {
        darkColorSchemeData = colorSchemeData;
      }
      lightTheme =
          getTheme(colorSchemeData: colorSchemeData, styleTheme: styleTheme);
      darkTheme = getTheme(
          colorSchemeData: darkColorSchemeData, styleTheme: styleTheme);
      return AppTheme(lightTheme: lightTheme, darkTheme: darkTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      final AppTheme appTheme = getAppTheme(lightDynamic, darkDynamic);
      ThemeBrightness themeBrightness =
          _colorSettings.getSetting("Brightness").value;

      return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        navigatorKey: App.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: getAppName(),
        theme: appTheme.lightTheme,
        darkTheme: appTheme.darkTheme,
        themeMode: themeBrightness == ThemeBrightness.system
            ? ThemeMode.system
            : themeBrightness == ThemeBrightness.light
                ? ThemeMode.light
                : ThemeMode.dark,
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
    });
  }
}
