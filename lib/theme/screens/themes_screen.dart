import 'package:clock_app/common/logic/customize_screen.dart';
import 'package:clock_app/common/widgets/list/customize_list_item_screen.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/theme/types/theme_item.dart';
import 'package:clock_app/theme/widgets/theme_card.dart';
import 'package:clock_app/theme/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';

class ThemesScreen<Item extends ThemeItem> extends StatefulWidget {
  const ThemesScreen({
    super.key,
    required this.saveTag,
    required this.setting,
    required this.getThemeFromItem,
    required this.createThemeItem,
  });

  final String saveTag;
  final CustomSetting<Item> setting;
  final ThemeData Function(ThemeData, Item) getThemeFromItem;
  final Item Function() createThemeItem;

  @override
  State<ThemesScreen> createState() => _ThemesScreenState<Item>();
}

class _ThemesScreenState<Item extends ThemeItem>
    extends State<ThemesScreen<Item>> {
  final _listController = PersistentListController<Item>();

  Future<Item?> _openCustomizeItemScreen(
    Item themeItem, {
    Future<void> Function(Item)? onSave,
    bool isNewItem = false,
  }) async {
    return openCustomizeScreen(
      context,
      CustomizeListItemScreen(
        item: themeItem,
        isNewItem: isNewItem,
        itemPreviewBuilder: (item) {
          ThemeData theme = Theme.of(context);
          ThemeData themeData = widget.getThemeFromItem(theme, item);
          return Theme(
            data: themeData,
            child: const ThemePreviewCard(),
          );
        },
      ),
      onSave: onSave,
    );
  }

  _handleCustomizeItem(Item themeItem) async {
    int index = _listController.getItemIndex(themeItem);
    await _openCustomizeItemScreen(
      themeItem,
      onSave: (newThemItem) async {
        if (widget.setting.value.id == themeItem.id) {
          widget.setting.setValue(context, newThemItem);
        }
        _listController
            .changeItems((colorSchemes) => colorSchemes[index] = newThemItem);
      },
    );
  }

  void _onDeleteItem(ThemeItem themeItem) {
    // If the theme item is currently selected, change the theme item to the default one
    if (widget.setting.value.id == themeItem.id) {
      widget.setting.restoreDefault(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        titleWidget: Text(widget.setting.displayName(context)),
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
                    onPressEdit: () => _handleCustomizeItem(themeItem),
                    onPressDelete: () => _listController.deleteItem(themeItem),
                    onPressDuplicate: () =>
                        _listController.duplicateItem(themeItem),
                    getThemeFromItem: widget.getThemeFromItem,
                  ),
                  onTapItem: (themeItem, index) {
                    widget.setting.setValue(context, themeItem);
                    _listController.reload();
                  },
                  onDeleteItem: _onDeleteItem,
                  placeholderText: "No custom color schemes",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            bottomPadding: 8,
            onPressed: () async {
              Item? themeItem = widget.createThemeItem();
              await _openCustomizeItemScreen(
                themeItem,
                onSave: (newThemeItem) async {
                  _listController.addItem(newThemeItem);
                },
                isNewItem: true,
              );
            },
          )
        ],
      ),
    );
  }
}
