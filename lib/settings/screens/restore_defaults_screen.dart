import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:clock_app/settings/widgets/settings_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingCheckBox extends StatelessWidget {
  const SettingCheckBox(
      {super.key,
      required this.settingItem,
      required this.isChecked,
      required this.onChanged});

  final SettingItem settingItem;

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

class RestoreDefaultScreen extends StatefulWidget {
  const RestoreDefaultScreen({
    super.key,
    required this.settingGroup,
    required this.onRestore,
  });

  final SettingGroup settingGroup;
  final void Function() onRestore;

  @override
  State<RestoreDefaultScreen> createState() => _RestoreDefaultScreenState();
}

class _RestoreDefaultScreenState extends State<RestoreDefaultScreen> {
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
