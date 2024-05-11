import 'package:clock_app/common/utils/time_format.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void setDigitalClockWidgetData(BuildContext context) async {
  final digitalClockSettingGroup =
      appSettings.getGroup('Widgets').getGroup('Digital Clock');
  final bool showDate =
      digitalClockSettingGroup.getGroup('Layout').getSetting('Show Date').value;
  final int timeSize = digitalClockSettingGroup
      .getGroup('Layout')
      .getSetting('Time Size')
      .value
      .round();
  final int dateSize = digitalClockSettingGroup
      .getGroup('Layout')
      .getSetting('Date Size')
      .value
      .round();
  final String textColor =
      '#${digitalClockSettingGroup.getGroup('Text').getSetting('Color').value.value.toRadixString(16)}';
  final String timeFormat = getTimeFormatString(context, appSettings
      .getGroup('General')
      .getGroup('Display')
      .getSetting('Time Format')
      .value);

  await HomeWidget.saveWidgetData("timeFormat", timeFormat);
  await HomeWidget.saveWidgetData<bool>('showDate', showDate);
  await HomeWidget.saveWidgetData<int>('timeSize', timeSize);
  await HomeWidget.saveWidgetData<int>('dateSize', dateSize);
  await HomeWidget.saveWidgetData<String>('textColor', textColor);

  updateDigitalClockWidget();
}

void updateDigitalClockWidget() {
  HomeWidget.updateWidget(
    androidName: 'DigitalClockWidgetProvider',
    name: 'DigitalClockWidgetProvider',
    qualifiedAndroidName: 'com.vicolo.chrono.DigitalClockWidgetProvider',
  );
}
