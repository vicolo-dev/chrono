import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/customize_screen.dart';
import 'package:clock_app/settings/logic/get_setting_widget.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';

class CustomizeListItemScreen<Item extends ListItem> extends StatefulWidget {
  const CustomizeListItemScreen({
    super.key,
    required this.item,
    required this.getSettings,
  });

  final Item item;
  final SettingGroup Function(Item item) getSettings;

  @override
  State<CustomizeListItemScreen> createState() =>
      _CustomizeListItemScreenState<Item>();
}

class _CustomizeListItemScreenState<Item extends ListItem>
    extends State<CustomizeListItemScreen<Item>> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return CustomizeScreen(
        item: widget.item,
        builder: (context, item) {
          return Stack(children: [
            Column(
              children: [
                // CardContainer(
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child:
                //             Text("Preview", style: theme.textTheme.titleMedium),
                //       ),
                //     ],
                //   ),
                // ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        ...getSettingWidgets(
                          widget.getSettings(item).settingItems,
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
              ],
            ),
          ]);
        });
  }
}
