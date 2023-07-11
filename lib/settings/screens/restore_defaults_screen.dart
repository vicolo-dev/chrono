// ignore_for_file: prefer_const_constructors

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:flutter/material.dart';

class SettingCheckBox extends StatelessWidget {
  const SettingCheckBox(
      {Key? key,
      required this.settingItem,
      required this.isChecked,
      required this.onChanged})
      : super(key: key);

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
          settingItem.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class RestoreDefaultScreen extends StatefulWidget {
  const RestoreDefaultScreen(
      {super.key,
      required this.settingsGroup,
      required this.onRestore,
      required this.settings});

  final SettingGroup settingsGroup;
  final Settings settings;
  final void Function() onRestore;

  @override
  State<RestoreDefaultScreen> createState() => _RestoreDefaultScreenState();
}

class _RestoreDefaultScreenState extends State<RestoreDefaultScreen> {
  late final Map<String, bool> _settingsToRestore = {
    for (var settingItem in widget.settingsGroup.settingItems)
      settingItem.id: true
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: Hero(
          tag: "Reset to Default",
          child: Text("Reset to Default",
              style: Theme.of(context).textTheme.titleMedium),
        ),
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
                      Text("Reset",
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
                  widget.settingsGroup.restoreDefault(
                      context, widget.settings, _settingsToRestore);
                  widget.onRestore();
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16),
              ...widget.settingsGroup.settingItems
                  .map(
                    (settingItem) => SettingCheckBox(
                      settingItem: settingItem,
                      isChecked: _settingsToRestore[settingItem.id] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          _settingsToRestore[settingItem.id] = value!;
                        });
                      },
                    ),
                  )
                  .toList(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
