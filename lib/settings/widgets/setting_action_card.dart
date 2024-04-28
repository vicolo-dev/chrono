import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:flutter/material.dart';

class SettingActionCard extends StatefulWidget {
  const SettingActionCard({
    super.key,
    required this.setting,
    this.showAsCard = true,
  });

  final SettingAction setting;
  final bool showAsCard;

  @override
  State<SettingActionCard> createState() => _SettingActionCardState();
}

class _SettingActionCardState<T> extends State<SettingActionCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    String description = widget.setting.getDescription(context);

    Widget inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.setting.action(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.setting.displayName(context),
                      style: textTheme.displaySmall,
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: textTheme.bodyMedium,
                      )
                    ]
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.showAsCard ? CardContainer(child: inner) : inner;
  }
}
