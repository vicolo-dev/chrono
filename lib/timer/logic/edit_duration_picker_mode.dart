import 'package:clock_app/common/logic/show_select.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/settings/data/general_settings_schema.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

Future<void> editDurationPickerMode(
    BuildContext context, VoidCallback onChange) async {
  SelectSetting<DurationPickerType> setting = appSettings
      .getGroup("General")
      .getGroup("Display")
      .getSetting("Duration Picker") as SelectSetting<DurationPickerType>;

  await showSelectBottomSheet(
    context,
    (List<int>? selectedIndices) async {
      setting.setValue(context, selectedIndices?[0] ?? setting.selectedIndex);
      onChange();
      // setState(() {});
    },
    title: setting.name,
    description: setting.getDescription(context),
    choices: setting.options
        .map((option) => SelectChoice(
            name: option.getLocalizedName(context),
            value: option.value,
            description: option.getDescription(context)))
        .toList(),
    initialSelectedIndices: [setting.selectedIndex],
    multiSelect: false,
  );

  appSettings.save();
}
