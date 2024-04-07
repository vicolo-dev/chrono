import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/common/utils/popup_action.dart';
import 'package:clock_app/common/widgets/card_edit_menu.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

class AlarmTaskCard extends StatelessWidget {
  const AlarmTaskCard(
      {super.key,
      required this.task,
      required this.isAddCard,
      this.onPressDelete,
      this.onPressDuplicate});

  final AlarmTask task;
  final bool isAddCard;
  final VoidCallback? onPressDelete;
  final VoidCallback? onPressDuplicate;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: isAddCard ? 8.0 : 16.0,
              bottom: isAddCard ? 8.0 : 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.name, style: textTheme.displaySmall),
                  ],
                ),
              ),
              const Spacer(),
              if (onPressDuplicate != null || onPressDelete != null)
                CardEditMenu(actions: [
                  if (onPressDelete != null)
                    getDeletePopupAction(context, onPressDelete!),
                  if (onPressDuplicate != null)
                    getDuplicatePopupAction(onPressDuplicate!),
                ]),
              if (!isAddCard)
                Icon(FluxIcons.settings, color: colorScheme.onSurface),
            ],
          ),
        ),
      ],
    );
  }
}
