import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/system/data/device_info.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ColorSchemeType {
  custom,
  app,
}

SettingGroup widgetSettingSchema = SettingGroup(
  "Widgets",
  (context) => AppLocalizations.of(context)!.widgetsSettingGroup,
  [
    SettingGroup(
      "Digital Clock",
      (context) => AppLocalizations.of(context)!.digitalClockSettingGroup,
      [
        SelectSetting(
          "colorScheme",
          (context) => AppLocalizations.of(context)!.colorSchemeSetting,
          [
            SelectSettingOption(
                (context) => AppLocalizations.of(context)!.custom,
                ColorSchemeType.custom),
            SelectSettingOption((context) => AppLocalizations.of(context)!.app,
                ColorSchemeType.app),
          ],
          onChange: (context, value) async {
            if (value > 0) {
              appSettings
                  .getGroup('Widgets')
                  .getGroup('Digital Clock')
                  .getGroup('background')
                  .getSetting('backgroundOpacity')
                  .setValue(context, 100.0);
              await appSettings.save();
            }
            if (context.mounted) {
              setDigitalClockWidgetData(context);
            }
          },
        ),
        SettingGroup(
          "Layout",
          (context) => AppLocalizations.of(context)!.layoutSettingGroup,
          [
            SelectSetting(
              "Horizontal Alignment",
              (context) =>
                  AppLocalizations.of(context)!.horizontalAlignmentSetting,
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
              enableConditions: [
                GeneralCondition(
                    () => (androidInfo?.version.sdkInt ?? 34) >= 31)
              ],
              defaultValue: 1,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
            // SelectSetting(
            //   "Vertical Alignment",
            //   (context) =>
            //       AppLocalizations.of(context)!.verticalAlignmentSetting,
            //   [
            //     SelectSettingOption(
            //         (context) => AppLocalizations.of(context)!.alignmentTop,
            //         30),
            //     SelectSettingOption(
            //         (context) => AppLocalizations.of(context)!.alignmentCenter,
            //         10),
            //     SelectSettingOption(
            //         (context) => AppLocalizations.of(context)!.alignmentBottom,
            //         50),
            //     // SelectSettingOption(
            //     //     (context) => AppLocalizations.of(context)!.alignmentJustify,
            //     //     7),
            //   ],
            //   defaultValue: 1,
            //   onChange: (context, value) async {
            //     setDigitalClockWidgetData(context);
            //   },
            // ),
          ],
        ),
        SettingGroup(
          "Time",
          (context) => AppLocalizations.of(context)!.timeSettingGroup,
          [
            SwitchSetting(
                "Show Meridiem",
                (context) => AppLocalizations.of(context)!.showMeridiemSetting,
                false, onChange: (context, value) async {
              setDigitalClockWidgetData(context);
            }),
            SliderSetting(
              "Size",
              (context) => AppLocalizations.of(context)!.sizeSetting,
              10,
              150,
              70,
              enableConditions: [
                GeneralCondition(
                    () => (androidInfo?.version.sdkInt ?? 34) >= 26),
                // ValueCondition(["..", "colorScheme"],
                // (value) => value == ColorSchemeType.custom)
              ],

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
            SelectSetting(
              "Separator",
              (context) => AppLocalizations.of(context)!.separatorSetting,
              [
                SelectSettingOption(
                    (context) => AppLocalizations.of(context)!.defaultLabel,
                    "default"),
                SelectSettingOption((context) => ".", "."),
                SelectSettingOption((context) => ":", ":"),
                SelectSettingOption((context) => "/", "/"),
                SelectSettingOption((context) => "-", "-"),
                SelectSettingOption((context) => "Space", " "),
              ],
              defaultValue: 0,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
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
              150,
              15,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
              enableConditions: [
                ValueCondition(["Show Date"], (value) => value == true),
                GeneralCondition(
                    () => (androidInfo?.version.sdkInt ?? 34) >= 26)
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
        SettingGroup(
          "background",
          (context) =>
              AppLocalizations.of(context)!.colorSchemeBackgroundSettingGroup,
          [
            ColorSetting(
              "backgroundColor",
              (context) => AppLocalizations.of(context)!.colorSetting,
              Colors.black,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
            SliderSetting(
              "backgroundBorderRadius",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeRadiusSetting,
              0,
              64,
              0,
              snapLength: 4,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            ),
            SliderSetting(
              "backgroundOpacity",
              (context) =>
                  AppLocalizations.of(context)!.styleThemeOpacitySetting,
              0,
              100,
              0,
              onChange: (context, value) async {
                setDigitalClockWidgetData(context);
              },
            )
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
