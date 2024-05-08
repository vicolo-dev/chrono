import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/material.dart';

class SettingPageLinkCard extends StatefulWidget {
  const SettingPageLinkCard({
    super.key,
    required this.setting,
    this.showAsCard = true,
  });

  final SettingPageLink setting;
  final bool showAsCard;

  @override
  State<SettingPageLinkCard> createState() => _SettingPageLinkCardState();
}

class _SettingPageLinkCardState<T> extends State<SettingPageLinkCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    String description = widget.setting.getDescription(context);
    Widget inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => widget.setting.screen,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (widget.setting.icon != null)
                Icon(
                  widget.setting.icon,
                  color: colorScheme.onBackground,
                ),
              if (widget.setting.icon != null) const SizedBox(width: 16),
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
