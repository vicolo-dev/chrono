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
    Widget inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.setting.action,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                widget.setting.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.showAsCard ? CardContainer(child: inner) : inner;
  }
}
