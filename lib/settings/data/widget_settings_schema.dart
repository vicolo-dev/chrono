import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_widget/home_widget.dart';

SettingGroup widgetSettingSchema = SettingGroup(
  "Widgets",
  (context) => AppLocalizations.of(context)!.widgetsSettingGroup,
  [
    SettingGroup(
      "Digital Clock",
      (context) => AppLocalizations.of(context)!.digitalClockSettingGroup,
      [
        SettingGroup(
          "Layout",
          (context) => AppLocalizations.of(context)!.layoutSettingGroup,
          [
            SwitchSetting(
              "Show Date",
              (context) => AppLocalizations.of(context)!.showDateSetting,
              true,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
            SliderSetting(
              "Time Size",
              (context) => AppLocalizations.of(context)!.timeSizeSetting,
              10,
              100,
              100,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              // snapLength: 1,
            ),
            SliderSetting(
              "Date Size",
              (context) => AppLocalizations.of(context)!.dateSizeSetting,
              10,
              100,
              25,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              enableConditions: [
                ValueCondition(["Show Date"], (value) => value == true)
              ],
              // snapLength: 1,
            ),
          ],
        ),
        SettingGroup(
          "Text",
          (context) => AppLocalizations.of(context)!.textSettingGroup,
          [
            ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.white,
              // enableOpacity: true,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
          ],
        ),
        // SettingGroup(
        //   "Shadow",
        //   (context) =>
        //       AppLocalizations.of(context)!.styleThemeShadowSettingGroup,
        //   [
        //     SliderSetting(
        //       "Elevation",
        //       (context) =>
        //           AppLocalizations.of(context)!.styleThemeElevationSetting,
        //       0,
        //       5,
        //       1,
        //       onChange: (context, value) async {
        //         await HomeWidget.saveWidgetData<double>(
        //             "shadowElevation", value);
        //         updateDigitalClockWidget();
        //       },
        //     ),
        //     SliderSetting(
        //       "Blur",
        //       (context) => AppLocalizations.of(context)!.styleThemeBlurSetting,
        //       0,
        //       5,
        //       1,
        //       onChange: (context, value) async {
        //         await HomeWidget.saveWidgetData<double>("shadowBlur", value);
        //         updateDigitalClockWidget();
        //       },
        //     ),
        //     ColorSetting(
        //       "Color",
        //       (context) => AppLocalizations.of(context)!.colorSetting,
        //       Colors.black,
        //       enableOpacity: true,
        //       onChange: (context, value) async {
        //         await HomeWidget.saveWidgetData<String>(
        //             "shadowColor", '#${value.value.toRadixString(16)}');
        //         updateDigitalClockWidget();
        //       },
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
  icon: Icons.widgets_outlined,
);
