import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';
import 'package:clock_app/notifications/data/update_notification_intervals.dart';
import 'package:clock_app/notifications/logic/notifications_listeners.dart';
import 'package:clock_app/notifications/types/alarm_notification_arguments.dart';
import 'package:clock_app/onboarding/screens/onboarding_screen.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/system/data/app_info.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/types/theme_brightness.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Setting _animationSpeedSetting;
  late SettingGroup _generalSettings;

  @override
  void initState() {
    super.initState();

    setDigitalClockWidgetData(context);

    setNotificationListeners();

    _appearanceSettings = appSettings.getGroup("Appearance");
    _colorSettings = _appearanceSettings.getGroup("Colors");
    _styleSettings = _appearanceSettings.getGroup("Style");
    _generalSettings = appSettings.getGroup("General");
    _animationSpeedSetting =
        _appearanceSettings.getGroup("Animations").getSetting("Animation Speed");
    _animationSpeedSetting.addListener(setAnimationSpeed);

    setAnimationSpeed(_animationSpeedSetting.value);
  }

  void setAnimationSpeed(dynamic speed) {
    timeDilation = 1 / speed;
  }

  refreshTheme() {
    setState(() {});
  }

  @override
  void dispose() {
    stopwatchNotificationInterval?.cancel();
    timerNotificationInterval?.cancel();
    AwesomeNotifications()
        .cancelNotificationsByChannelKey(stopwatchNotificationChannelKey);
    AwesomeNotifications()
        .cancelNotificationsByChannelKey(timerNotificationChannelKey);

    _animationSpeedSetting.removeListener(setAnimationSpeed);

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
      Locale locale = _generalSettings.getSetting("Language").value;

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
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          Routes.push(settings.name ?? Routes.rootRoute);
          switch (settings.name) {
            case Routes.rootRoute:
              final bool? onboarded = GetStorage().read('onboarded');
              if (onboarded == null) {
                return MaterialPageRoute(
                    builder: (context) => const OnBoardingScreen());
              } else {
                final defaultTab = appSettings
                    .getGroup("General")
                    .getSetting("Default Tab")
                    .value;
                final arguments = (ModalRoute.of(context)?.settings.arguments ??
                    <String, dynamic>{"tab": defaultTab}) as Map;
                return MaterialPageRoute(
                    builder: (context) => NavScaffold(
                          initialTabIndex: arguments["tab"],
                        ));
              }

            case Routes.alarmNotificationRoute:
              return MaterialPageRoute(
                builder: (context) {
                  final args = settings.arguments as AlarmNotificationArguments;
                  return AlarmNotificationScreen(
                    scheduleId: args.scheduleIds[0],
                    initialIndex: args.tasksOnly ? 0 : -1,
                    dismissType: args.dismissType,
                  );
                },
              );

            case Routes.timerNotificationRoute:
              return MaterialPageRoute(
                builder: (context) {
                  final args = settings.arguments as AlarmNotificationArguments;
                  return TimerNotificationScreen(scheduleIds: args.scheduleIds);
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
