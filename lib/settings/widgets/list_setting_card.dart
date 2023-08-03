import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/widgets/list_setting_screen.dart';
import 'package:flutter/material.dart';

class ListSettingCard extends StatefulWidget {
  const ListSettingCard({
    Key? key,
    required this.setting,
    this.showAsCard = true,
  }) : super(key: key);

  final ListSetting setting;
  final bool showAsCard;

  @override
  State<ListSettingCard> createState() => _ListSettingCardState();
}

class _ListSettingCardState extends State<ListSettingCard> {
  @override
  Widget build(BuildContext context) {
    Widget inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ListSettingScreen(setting: widget.setting),
            ),
          );
          setState(() {});
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
                  widget.setting.getValueDisplayWidget(context),
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
