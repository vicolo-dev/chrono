import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class ListSettingAddBottomSheet<Item extends CustomizableListItem>
    extends StatelessWidget {
  const ListSettingAddBottomSheet({
    required this.setting,
    super.key,
  });

  final ListSetting<Item> setting;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    BorderRadiusGeometry borderRadius = theme.cardTheme.shape != null
        ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
        : BorderRadius.circular(8.0);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            SizedBox(
              height: 4.0,
              width: 48,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    color: theme.colorScheme.onBackground.withOpacity(0.6)),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose Task to Add",
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: ListView.builder(
                  itemCount: setting.possibleItems.length,
                  itemBuilder: (context, index) {
                    Item item = setting.possibleItems[index];
                    Widget widget = setting.getItemAddCard(item);
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                        child: widget,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
