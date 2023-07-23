import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:flutter/material.dart';

class CustomSettingCard extends StatefulWidget {
  const CustomSettingCard({
    Key? key,
    required this.setting,
    this.showAsCard = true,
  }) : super(key: key);

  final CustomSetting setting;
  final bool showAsCard;

  @override
  State<CustomSettingCard> createState() => _CustomSettingCardState();
}

class _CustomSettingCardState<T> extends State<CustomSettingCard> {
  @override
  Widget build(BuildContext context) {
    Widget inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => widget.setting.getWidget(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.setting.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4.0),
                  // const Spacer(),
                  Text(
                    widget.setting.getValueName(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
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
