import 'dart:convert';

import 'package:clock_app/alarm/logic/update_alarms.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/app.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/widgets/settings_top_bar.dart';
import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:clock_app/theme/types/style_theme.dart';
import 'package:clock_app/timer/logic/update_timers.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:clock_app/widgets/logic/update_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingCheckBox extends StatelessWidget {
  const SettingCheckBox(
      {super.key,
      required this.settingItem,
      required this.isChecked,
      required this.onChanged});

  final bool isChecked;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          // checkColor: Colors.white,
          // fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: onChanged,
        ),
        Text(
          settingItem.displayName(context),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class BackupExportScreen extends StatefulWidget {
  const BackupExportScreen({
    super.key,
    required this.settingGroup,
    required this.onRestore,
  });

  final SettingGroup settingGroup;
  final void Function() onRestore;

  @override
  State<BackupExportScreen> createState() => _BackupExportScreenState();
}

class BackupOption {
  final String Function(BuildContext context) getName;
  final String key;
  final dynamic Function() encode;
  final Function(BuildContext context, dynamic value) decode;
  bool selected = true;

  BackupOption(this.key, this.getName,
      {required this.encode, required this.decode});
}

final backupOptions = [
  BackupOption(
    "settings",
    (context) => AppLocalizations.of(context)!.settings,
    encode: () async {
      return json.encode(appSettings.valueToJson());
    },
    decode: (context, value) async {
      appSettings.loadValueFromJson(json.decode(value));
      appSettings.callAllListeners();
      App.refreshTheme(context);
      await appSettings.save();
      if (context.mounted) {
        setDigitalClockWidgetData(context);
      }
    },
  ),
  BackupOption(
    "color_schemes",
    (context) => AppLocalizations.of(context)!.colorSchemeSetting,
    encode: () async {
      List<ColorSchemeData> colorSchemes = await loadList("color_schemes");
      List<ColorSchemeData> customColorSchemes =
          colorSchemes.where((scheme) => !scheme.isDefault).toList();
      return json.encode(customColorSchemes);
    },
    decode: (context, value) async {
      List<ColorSchemeData> colorSchemes =
          await loadList<ColorSchemeData>("color_schemes");
      await saveList<ColorSchemeData>(
          "color_schemes", [...json.decode(value), ...colorSchemes]);
      if (context.mounted) App.refreshTheme(context);
    },
  ),
  BackupOption(
    "style_themes",
    (context) => AppLocalizations.of(context)!.styleThemeSetting,
    encode: () async {
      List<StyleTheme> styleThemes = await loadList("style_themes");
      List<StyleTheme> customThemes =
          styleThemes.where((scheme) => !scheme.isDefault).toList();
      return json.encode(customThemes);
    },
    decode: (context, value) async {
      List<ColorSchemeData> styleThemes =
          await loadList<ColorSchemeData>("style_themes");
      await saveList<ColorSchemeData>(
          "style_themes", [...json.decode(value), ...styleThemes]);
      if (context.mounted) App.refreshTheme(context);
    },
  ),
  BackupOption(
    "alarms",
    (context) => AppLocalizations.of(context)!.alarmTitle,
    encode: () async {
      return json.encode(await loadList("alarms"));
    },
    decode: (context, value) async {
      await saveList<Alarm>("alarms", [...json.decode(value), ...await loadList("alarms")]);
      await updateAlarms("Updated alarms on importing backup");
      if (context.mounted) App.refreshTheme(context);
    },
  ),
  BackupOption(
    "timers",
    (context) => AppLocalizations.of(context)!.alarmTitle,
    encode: () async {
      return json.encode(await loadList("timers"));
    },
    decode: (context, value) async {
      await saveList<ClockTimer>("timers", [...json.decode(value), ...await loadList("timers")]);
      await updateTimers("Updated timers on importing backup");
      if (context.mounted) App.refreshTheme(context);
    },
  ),
 ];

class _BackupExportScreenState extends State<BackupExportScreen> {
  bool settings = false;
  late final Map<String, bool> _settingsToRestore = {
    for (var settingItem in widget.settingGroup.settingItems)
      settingItem.id: true
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsTopBar(
        title: AppLocalizations.of(context)!.restoreSettingGroup,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              CardContainer(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.resetButton,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                    ],
                  ),
                ),
                onTap: () {
                  widget.settingGroup
                      .restoreDefaults(context, _settingsToRestore);
                  widget.onRestore();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ...widget.settingGroup.settingItems.map(
                (settingItem) => SettingCheckBox(
                  settingItem: settingItem,
                  isChecked: _settingsToRestore[settingItem.id] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _settingsToRestore[settingItem.id] = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
