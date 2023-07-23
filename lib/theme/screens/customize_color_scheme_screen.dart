import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/theme/color_scheme.dart';
import 'package:flutter/material.dart';

class CustomizeColorSchemeScreen extends StatefulWidget {
  const CustomizeColorSchemeScreen({
    super.key,
    required this.initialColorSchemeData,
    this.onColorSchemeChanged,
  });

  final ColorSchemeData initialColorSchemeData;
  final void Function(ColorSchemeData)? onColorSchemeChanged;

  @override
  State<CustomizeColorSchemeScreen> createState() =>
      _CustomizeColorSchemeScreenState();
}

class _CustomizeColorSchemeScreenState
    extends State<CustomizeColorSchemeScreen> {
  late ColorSchemeData _colorSchemeData;

  void update(value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _colorSchemeData = widget.initialColorSchemeData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(actions: [
        TextButton(
            onPressed: () {
              widget.onColorSchemeChanged?.call(_colorSchemeData);
              Navigator.pop(context);
            },
            child: const Text("Save"))
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ...getSettingWidgets(
                _colorSchemeData.settings.settingItems,
                checkDependentEnableConditions: () {
                  setState(() {});
                },
                isAppSettings: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
