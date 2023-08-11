import 'package:clock_app/common/logic/customize_screen.dart';
import 'package:clock_app/common/types/list_controller.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/list/customize_list_item_screen.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/custom_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/widgets/list_setting_add_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ListSettingScreen<Item extends CustomizableListItem>
    extends StatefulWidget {
  const ListSettingScreen({
    super.key,
    required this.setting,
  });

  final ListSetting<Item> setting;

  @override
  State<ListSettingScreen> createState() => _ListSettingScreenState<Item>();
}

class _ListSettingScreenState<Item extends CustomizableListItem>
    extends State<ListSettingScreen<Item>> {
  final _listController = ListController<Item>();

  Future<Item?> _openAddBottomSheet() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    return await showModalBottomSheet(
      context: context,
      builder: (context) => ListSettingAddBottomSheet(setting: widget.setting),
    );
  }

  _handleCustomizeItem(Item itemToCustomize) async {
    int index = _listController.getItemIndex(itemToCustomize);
    openCustomizeScreen<Item>(
      context,
      CustomizeListItemScreen<Item>(
        item: itemToCustomize,
        isNewItem: false,
        itemPreviewBuilder: (item) => widget.setting.getPreviewCard(item),
      ),
      onSave: (newItem) {
        _listController.changeItems((items) => items[index] = newItem);
      },
    );
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
                child: CustomListView<Item>(
                  listController: _listController,
                  items: widget.setting.value,
                  itemBuilder: (item) => widget.setting.getItemCard(item),
                  onTapItem: (task, index) {
                    _handleCustomizeItem(task);
                  },
                  onModifyList: () {},
                  placeholderText:
                      "No ${widget.setting.name.toLowerCase()} added yet",
                ),
              ),
            ],
          ),
          FAB(
            bottomPadding: 8,
            onPressed: () async {
              Item? item = await _openAddBottomSheet();
              if (item == null) return;
              _listController.addItem(item);
            },
          )
        ],
      ),
    );
  }
}
