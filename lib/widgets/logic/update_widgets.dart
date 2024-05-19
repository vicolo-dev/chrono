import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void setDigitalClockWidgetData(BuildContext context) async {
  try {
    final digitalClockSettingGroup =
        appSettings.getGroup('Widgets').getGroup('Digital Clock');
    final layoutSettingGroup = digitalClockSettingGroup.getGroup('Layout');
    final dateSettingGroup = digitalClockSettingGroup.getGroup('Date');
    final timeSettingGroup = digitalClockSettingGroup.getGroup('Time');
    final int horizontalAlignment =
        layoutSettingGroup.getSetting('Horizontal Alignment').value;
    final bool showDate = dateSettingGroup.getSetting('Show Date').value;
    final int timeSize = timeSettingGroup.getSetting('Size').value.round();
    final int dateSize = dateSettingGroup.getSetting('Size').value.round();
    final int timeFontWeight =
        timeSettingGroup.getSetting('Font Weight').value.round();
    final int dateFontWeight =
        dateSettingGroup.getSetting('Font Weight').value.round();
    final String timeColor =
        '#${timeSettingGroup.getSetting('Color').value.value.toRadixString(16)}';
    final String dateColor =
        '#${dateSettingGroup.getSetting('Color').value.value.toRadixString(16)}';
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

    await HomeWidget.saveWidgetData("timeFormat", timeFormat);
    await HomeWidget.saveWidgetData<bool>('showDate', showDate);
    await HomeWidget.saveWidgetData<int>('timeSize', timeSize);
    await HomeWidget.saveWidgetData<int>('dateSize', dateSize);
    await HomeWidget.saveWidgetData<String>('timeColor', timeColor);
    await HomeWidget.saveWidgetData<String>('dateColor', dateColor);
    await HomeWidget.saveWidgetData<int>(
        'horizontalAlignment', horizontalAlignment);
    // await HomeWidget.saveWidgetData<int>('verticalAlignment', verticalAlignment);
    await HomeWidget.saveWidgetData<int>('timeFontWeight', timeFontWeight);
    await HomeWidget.saveWidgetData<int>('dateFontWeight', dateFontWeight);

    updateDigitalClockWidget();
  } catch (e) {
    debugPrint("Couldn't update Digital Clock Widget: $e");
  }
}

void updateDigitalClockWidget() {
  HomeWidget.updateWidget(
    androidName: 'DigitalClockWidgetProvider',
    name: 'DigitalClockWidgetProvider',
    qualifiedAndroidName: 'com.vicolo.chrono.DigitalClockWidgetProvider',
  );
}
