import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/developer/logic/logger.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/widgets/data/widget_settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void setDigitalClockWidgetData(BuildContext context) async {
  try {
    ColorScheme colorScheme=Theme.of(context).colorScheme;

    final digitalClockSettingGroup =
        appSettings.getGroup('Widgets').getGroup('Digital Clock');
    final layoutSettingGroup = digitalClockSettingGroup.getGroup('Layout');
    final dateSettingGroup = digitalClockSettingGroup.getGroup('Date');
    final timeSettingGroup = digitalClockSettingGroup.getGroup('Time');
    final backgroundSettingGroup =
        digitalClockSettingGroup.getGroup('background');

    final ColorSchemeType colorSchemeType =
        digitalClockSettingGroup.getSetting('colorScheme').value;
    final int horizontalAlignment =
        layoutSettingGroup.getSetting('Horizontal Alignment').value;
    final bool showDate = dateSettingGroup.getSetting('Show Date').value;
    final int timeSize = timeSettingGroup.getSetting('Size').value.round();
    final int dateSize = dateSettingGroup.getSetting('Size').value.round();
    final int timeFontWeight =
        timeSettingGroup.getSetting('Font Weight').value.round();
    final int dateFontWeight =
        dateSettingGroup.getSetting('Font Weight').value.round();
    final Color appTextColor = colorScheme.onSurface;
    final Color appAccentColor = colorScheme.primary;
    final Color dateColor = colorSchemeType == ColorSchemeType.custom
        ? dateSettingGroup.getSetting('Color').value
        : appTextColor;
    final Color timeColor = colorSchemeType == ColorSchemeType.custom
        ? timeSettingGroup.getSetting('Color').value
        : appAccentColor;
    final String timeColorString = '#${timeColor.value.toRadixString(16)}';
    final String dateColorString = '#${dateColor.value.toRadixString(16)}';
    final bool showMeridiem =
        timeSettingGroup.getSetting('Show Meridiem').value;
    final String separator =
        timeSettingGroup.getSetting('Separator').value.toString();
    final String timeFormat = getTimeFormatString(
      context,
      appSettings
          .getGroup('General')
          .getGroup('Display')
          .getSetting('Time Format')
          .value,
      showMeridiem: showMeridiem,
      separator: separator,
    );
    final String dateFormat = appSettings
        .getGroup('General')
        .getGroup('Display')
        .getSetting('Long Date Format')
        .value;
    final Color appBackgroundColor = getCardColor(context);
    final Color backgroundColor = colorSchemeType == ColorSchemeType.custom
        ? backgroundSettingGroup.getSetting('backgroundColor').value
        : appBackgroundColor;

    final String backgroundColorString =
        '#${backgroundColor.value.toRadixString(16)}';
    final int backgroundOpacity =
        backgroundSettingGroup.getSetting('backgroundOpacity').value.round();
    final int backgroundBorderRadius = backgroundSettingGroup
        .getSetting('backgroundBorderRadius')
        .value
        .round();


    await HomeWidget.saveWidgetData("timeFormat", timeFormat);
    await HomeWidget.saveWidgetData("dateFormat", dateFormat);
    await HomeWidget.saveWidgetData<bool>('showDate', showDate);
    await HomeWidget.saveWidgetData<int>('timeSize', timeSize);
    await HomeWidget.saveWidgetData<int>('dateSize', dateSize);
    await HomeWidget.saveWidgetData<String>('timeColor', timeColorString);
    await HomeWidget.saveWidgetData<String>('dateColor', dateColorString);
    await HomeWidget.saveWidgetData<int>(
        'horizontalAlignment', horizontalAlignment);
    // await HomeWidget.saveWidgetData<int>('verticalAlignment', verticalAlignment);
    await HomeWidget.saveWidgetData<int>('timeFontWeight', timeFontWeight);
    await HomeWidget.saveWidgetData<int>('dateFontWeight', dateFontWeight);
    await HomeWidget.saveWidgetData<int>(
        'backgroundOpacity', backgroundOpacity);
    await HomeWidget.saveWidgetData<int>(
        'backgroundBorderRadius', backgroundBorderRadius);
    await HomeWidget.saveWidgetData<String>(
        'backgroundColor', backgroundColorString);

    updateDigitalClockWidget();
  } catch (e) {
    logger.e("Couldn't update Digital Clock Widget: $e");
  }
}

void updateDigitalClockWidget() {
  HomeWidget.updateWidget(
    androidName: 'DigitalClockWidgetProvider',
    name: 'DigitalClockWidgetProvider',
    qualifiedAndroidName: 'com.vicolo.chrono.DigitalClockWidgetProvider',
  );
}
