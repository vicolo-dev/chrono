import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/theme/screens/customize_theme_settings_screen.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:clock_app/theme/widgets/theme_card.dart';
import 'package:flutter/material.dart';

class ThemesScreen<Item extends ThemeItem> extends StatefulWidget {
  const ThemesScreen({
    super.key,
    required this.saveTag,
    required this.setting,
    required this.getThemeFromItem,
    required this.createThemItem,
    required this.fromItem,
  });

  final String saveTag;
  final CustomSetting<Item> setting;
  final ThemeData Function(ThemeData, Item) getThemeFromItem;
  final Item Function() createThemItem;
  final Item Function(Item) fromItem;

  @override
  State<ThemesScreen> createState() => _ThemesScreenState<Item>();
}

class _ThemesScreenState<Item extends ThemeItem>
    extends State<ThemesScreen<Item>> {
  final _listController = PersistentListController<Item>();

  Future<Item?> _openCustomizeItemScreen(
    Item themeItem, {
    void Function()? onThemeSettingsChanged,
  }) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomizeThemeSettingsScreen(
          themeItem: themeItem,
          onSettingsChanged: onThemeSettingsChanged,
          getThemeFromItem: widget.getThemeFromItem,
        ),
      ),
    );
  }

  _handleCustomizeItem(Item themeItem) async {
    int index = _listController.getItemIndex(themeItem);
    await _openCustomizeItemScreen(
      themeItem,
      onThemeSettingsChanged: () {
        if (widget.setting.value.id == themeItem.id) {
          widget.setting.setValue(context, themeItem);
        }
      },
    );

    _listController
        .changeItems((colorSchemes) => colorSchemes[index] = themeItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: Text(widget.setting.name),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PersistentListView<Item>(
                  saveTag: widget.saveTag,
                  listController: _listController,
                  itemBuilder: (themeItem) => ThemeCard(
                    key: ValueKey(themeItem),
                    themeItem: themeItem,
                    isSelected: widget.setting.value.id == themeItem.id,
                    onPressEdit: () {
                      _handleCustomizeItem(themeItem);
                    },
                    getThemeFromItem: widget.getThemeFromItem,
                  ),
                  onTapItem: (themeItem, index) {
                    widget.setting.setValue(context, themeItem);
                    _listController.reload();
                  },
                  isItemDeletable: (themeItem) {
                    return !themeItem.isDefault;
                  },
                  onDeleteItem: (themeItem) {
                    // If the theme item is currently selected, change the theme item to the default one
                    if (widget.setting.value.id == themeItem.id) {
                      widget.setting.restoreDefault(context);
                    }
                  },
                  duplicateItem: (themeItem) => widget.fromItem(themeItem),
                  placeholderText: "No custom color schemes",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            bottomPadding: 8,
            onPressed: () async {
              Item? newItem = widget.createThemItem();
              await _openCustomizeItemScreen(newItem);
              _listController.addItem(newItem);
            },
          )
        ],
      ),
    );
  }
}
