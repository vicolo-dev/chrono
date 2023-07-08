import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/theme_extension.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:flutter/material.dart';

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

  static void setShadowSpreadRadius(BuildContext context, double radius) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setShadowSpreadRadius(radius);
  }

  static void setBorderWidth(BuildContext context, double width) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setBorderWidth(width);
  }

  static void setBorderColor(BuildContext context, Color color) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setBorderColor(color);
  }
}

class _AppState extends State<App> {
  ThemeData _theme = defaultTheme;

  late SettingGroup _appearanceSettings;
  late SettingGroup _colorSettings;
  late SettingGroup _shapeSettings;
  late SettingGroup _shadowSettings;
  late SettingGroup _borderSettings;

  @override
  void initState() {
    NotificationController.setListeners();

    _appearanceSettings = appSettings.getGroup("Appearance");
    _colorSettings = _appearanceSettings.getGroup("Colors");
    _shapeSettings = _appearanceSettings.getGroup("Shapes");
    _shadowSettings = _appearanceSettings.getGroup("Shadows");
    _borderSettings = _appearanceSettings.getGroup("Outlines");

    setColorScheme(_colorSettings.getSetting("Color Scheme").value);
    setAccentColor(_colorSettings.getSetting("Accent Color").value);
    setCardRadius(_shapeSettings.getSetting("Corner Roundness").value);
    setCardElevation(_shadowSettings.getSetting("Elevation").value);
    setShadowBlurRadius(_shadowSettings.getSetting("Blur").value);
    setShadowOpacity(_shadowSettings.getSetting("Opacity").value / 100);
    setShadowSpreadRadius(_shadowSettings.getSetting("Spread").value);
    setBorderWidth(_borderSettings.getSetting("Width").value);
    // setBorderColor(_borderSettings.getSetting("Color").value);

    super.initState();
  }

  setColorScheme(ColorScheme colorScheme) {
    setState(() {
      _theme = _theme.copyWith(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        cardColor: colorScheme.surface,
        dialogBackgroundColor: colorScheme.surface,
        bottomSheetTheme: getBottomSheetTheme(colorScheme,
            _theme.toggleButtonsTheme.borderRadius?.bottomLeft ?? Radius.zero),
        textTheme: _theme.textTheme.apply(
          bodyColor: colorScheme.onBackground,
          displayColor: colorScheme.onBackground,
        ),
        snackBarTheme: getSnackBarTheme(
            colorScheme, _theme.toggleButtonsTheme.borderRadius!),
        inputDecorationTheme:
            getInputTheme(colorScheme, _theme.toggleButtonsTheme.borderRadius!),
      );

      if (!_borderSettings.getSetting("Use Accent Color").value) {
        setBorderColor(Theme.of(context).colorScheme.onBackground);
      }

      setBorderColor(appSettings.getSetting("Use Accent Color").value
          ? _theme.colorScheme.primary
          : Theme.of(context).colorScheme.onBackground);
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

    setBorderColor(appSettings.getSetting("Use Accent Color").value
        ? _theme.colorScheme.primary
        : Theme.of(context).colorScheme.onBackground);
  }

  setCardRadius(double radius) {
    setState(() {
      RoundedRectangleBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );
      _theme = _theme.copyWith(
        cardTheme: _theme.cardTheme.copyWith(shape: shape),
        bottomSheetTheme:
            getBottomSheetTheme(_theme.colorScheme, Radius.circular(radius)),
        timePickerTheme: _theme.timePickerTheme.copyWith(
          shape: shape,
          dayPeriodShape: shape,
          hourMinuteShape: shape,
        ),
        toggleButtonsTheme: _theme.toggleButtonsTheme.copyWith(
          borderRadius: BorderRadius.circular(radius),
        ),
        snackBarTheme:
            getSnackBarTheme(_theme.colorScheme, BorderRadius.circular(radius)),
        inputDecorationTheme:
            getInputTheme(_theme.colorScheme, BorderRadius.circular(radius)),
        extensions: [
          _theme.extension<ThemeStyle>()?.copyWith(
                    borderRadius: radius,
                  ) ??
              const ThemeStyle(),
        ],
      );
    });
  }

  setCardElevation(double elevation) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  shadowElevation: elevation,
                ) ??
            const ThemeStyle(),
      ]);
    });
  }

  setShadowColor(Color color) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  shadowColor: color,
                ) ??
            const ThemeStyle(),
      ]);
    });
  }

  setShadowOpacity(double opacity) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  shadowOpacity: opacity,
                ) ??
            const ThemeStyle(),
      ]);
    });
  }

  setShadowBlurRadius(double blurRadius) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  shadowBlurRadius: blurRadius,
                ) ??
            const ThemeStyle(),
      ]);
    });
  }

  setShadowSpreadRadius(blurRadius) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  shadowSpreadRadius: blurRadius,
                ) ??
            const ThemeStyle(),
      ]);
    });
  }

  setBorderWidth(double width) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  borderWidth: width,
                ) ??
            const ThemeStyle(),
      ]);
    });
  }

  setBorderColor(Color color) {
    setState(() {
      _theme = _theme.copyWith(extensions: [
        _theme.extension<ThemeStyle>()?.copyWith(
                  borderColor: color,
                ) ??
            const ThemeStyle(),
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
