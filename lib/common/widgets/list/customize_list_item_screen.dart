import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/customize_screen.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:flutter/material.dart';

class CustomizeListItemScreen<Item extends CustomizableListItem>
    extends StatefulWidget {
  const CustomizeListItemScreen({
    super.key,
    required this.item,
    this.itemPreviewBuilder,
    required this.isNewItem,
    this.headerBuilder,
  });

  final Item item;
  final bool isNewItem;
  final Widget? Function(Item item)? itemPreviewBuilder;
  final Widget Function(Item item)? headerBuilder;

  @override
  State<CustomizeListItemScreen> createState() =>
      _CustomizeListItemScreenState<Item>();
}

class _CustomizeListItemScreenState<Item extends CustomizableListItem>
    extends State<CustomizeListItemScreen<Item>> {
  @override
  Widget build(BuildContext context) {
    return CustomizeScreen(
        item: widget.item,
        isNewItem: widget.isNewItem,
        builder: (context, item) {
          return Stack(children: [
            Column(
              children: [
                if (widget.itemPreviewBuilder != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: widget.itemPreviewBuilder?.call(item) ?? Container(),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.headerBuilder != null)
                            widget.headerBuilder!(item),
                          const SizedBox(height: 8),
                          ...getSettingWidgets(
                            item.settings.settingItems,
                            checkDependentEnableConditions: () {
                              setState(() {});
                            },
                            onSettingChanged: () {
                              setState(() {});
                            },
                            isAppSettings: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]);
        });
  }
}
