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
            SelectSetting(
              "Alignment",
              (context) => AppLocalizations.of(context)!.alignmentSetting,
              [
                SelectSettingOption(
                    (context) => AppLocalizations.of(context)!.alignmentLeft,
                    3),
                SelectSettingOption(
                    (context) => AppLocalizations.of(context)!.alignmentCenter,
                    1),
                SelectSettingOption(
                    (context) => AppLocalizations.of(context)!.alignmentRight,
                    5),
                // SelectSettingOption(
                //     (context) => AppLocalizations.of(context)!.alignmentJustify,
                //     7),
              ],
              defaultValue: 1,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
          ],
        ),
        SettingGroup(
          "Time",
          (context) => AppLocalizations.of(context)!.timeSettingGroup,
          [
            SliderSetting(
              "Size",
              (context) => AppLocalizations.of(context)!.sizeSetting,
              10,
              100,
              70,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              // snapLength: 1,
            ),
            ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.white,
              // enableOpacity: true,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
            SliderSetting(
              "Font Weight",
              (context) => AppLocalizations.of(context)!.fontWeightSetting,
              100,
              900,
              500,
              snapLength: 100,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              // snapLength: 1,
            ),
          ],
        ),

        SettingGroup(
          "Date",
          (context) => AppLocalizations.of(context)!.dateSettingGroup,
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
              "Size",
              (context) => AppLocalizations.of(context)!.sizeSetting,
              10,
              100,
              15,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              enableConditions: [
                ValueCondition(["Show Date"], (value) => value == true)
              ],
              // snapLength: 1,
            ),
            ColorSetting(
              "Color",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.white,
              // enableOpacity: true,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              enableConditions: [
                ValueCondition(["Show Date"], (value) => value == true)
              ],
            ),
            SliderSetting(
              "Font Weight",
              (context) => AppLocalizations.of(context)!.fontWeightSetting,
              100,
              900,
              500,
              snapLength: 100,
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
