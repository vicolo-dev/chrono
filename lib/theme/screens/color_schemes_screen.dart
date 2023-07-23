import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/theme/color_scheme.dart';
import 'package:clock_app/theme/data/default_color_schemes.dart';
import 'package:clock_app/theme/screens/customize_color_scheme_screen.dart';
import 'package:clock_app/theme/widgets/color_scheme_card.dart';
import 'package:flutter/material.dart';

import '../../settings/types/setting_group.dart';

class ColorSchemesScreen extends StatefulWidget {
  const ColorSchemesScreen({
    super.key,
    required this.setting,
  });

  final CustomSetting setting;

  @override
  State<ColorSchemesScreen> createState() => _ColorSchemesScreenState();
}

class _ColorSchemesScreenState extends State<ColorSchemesScreen> {
  final _listController = PersistentListController<ColorSchemeData>();

  Future<ColorSchemeData?> _openCustomizeColorSchemeScreen(
    ColorSchemeData colorSchemeData, {
    void Function(ColorSchemeData)? onColorSchemeChanged,
  }) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomizeColorSchemeScreen(
                initialColorSchemeData: colorSchemeData,
                onColorSchemeChanged: onColorSchemeChanged,
              )),
    );
  }

  _handleCustomizeColorScheme(ColorSchemeData colorSchemeData) async {
    int index = _listController.getItemIndex(colorSchemeData);
    await _openCustomizeColorSchemeScreen(
      colorSchemeData,
      onColorSchemeChanged: (newColorSchemeData) {
        if (widget.setting.value.id == colorSchemeData.id) {
          widget.setting.setValue(context, colorSchemeData);
        }
      },
    );

    _listController
        .changeItems((colorSchemes) => colorSchemes[index] = colorSchemeData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: Text("Color Schemes"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PersistentListView<ColorSchemeData>(
                  saveTag: 'color_schemes',
                  listController: _listController,
                  itemBuilder: (colorSchemeData) => ColorSchemeCard(
                    key: ValueKey(colorSchemeData),
                    colorSchemeData: colorSchemeData,
                    isSelected: widget.setting.value.id == colorSchemeData.id,
                    onPressEdit: () {
                      _handleCustomizeColorScheme(colorSchemeData);
                    },
                  ),
                  onTapItem: (colorSchemeData, index) {
                    widget.setting.setValue(context, colorSchemeData);
                    _listController.reload();
                  },
                  isItemDeletable: (colorSchemeData) {
                    return !colorSchemeData.isDefault;
                  },
                  onDeleteItem: (colorSchemeData) {
                    // If the color scheme is currently selected, change the color scheme to the default one
                    SettingGroup colorSettings =
                        appSettings.getGroup("Appearance").getGroup("Colors");
                    Setting colorSchemeSetting =
                        colorSettings.getSetting("Color Scheme");
                    ColorSchemeData selectedColorSchemeData =
                        colorSchemeSetting.value;
                    if (selectedColorSchemeData.id == colorSchemeData.id) {
                      colorSchemeSetting.setValue(context, 0);
                    }
                  },
                  duplicateItem: (colorSchemeData) =>
                      ColorSchemeData.from(colorSchemeData),
                  placeholderText: "No custom color schemes",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            bottomPadding: 8,
            onPressed: () async {
              ColorSchemeData? newColorSchemeData = ColorSchemeData();
              await _openCustomizeColorSchemeScreen(newColorSchemeData);
              _listController.addItem(newColorSchemeData);
            },
          )
        ],
      ),
    );
  }
}
