import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:flutter/material.dart';

class SettingActionCard extends StatefulWidget {
  const SettingActionCard({
    Key? key,
    required this.setting,
    this.showAsCard = true,
  }) : super(key: key);

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
                      widget.setting.name,
                      style: textTheme.displaySmall,
                    ),
                    if (widget.setting.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.setting.description,
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
