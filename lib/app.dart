import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/theme/utils/color_scheme.dart';
import 'package:clock_app/theme/utils/style_theme.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/services.dart';

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
}

class _AppState extends State<App> {
  ThemeData _theme = defaultTheme;

  late SettingGroup _appearanceSettings;
  late SettingGroup _colorSettings;
  late SettingGroup _styleSettings;

  @override
  void initState() {
    super.initState();

    NotificationController.setListeners();

    _appearanceSettings = appSettings.getGroup("Appearance");
    _colorSettings = _appearanceSettings.getGroup("Colors");
    _styleSettings = _appearanceSettings.getGroup("Style");

    setColorScheme(_colorSettings.getSetting("Color Scheme").value);
    setStyleTheme(_styleSettings.getSetting("Style Theme").value);

    initAutoStart();
  }

  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      var test = (await isAutoStartAvailable) ?? false;
      //if available then navigate to auto-start setting page.
      if (test) await getAutoStartPermission();
    } on PlatformException catch (e) {}
    if (!mounted) return;
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
