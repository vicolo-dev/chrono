import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SettingLinkCard extends StatefulWidget {
  const SettingLinkCard({
    Key? key,
    required this.setting,
  }) : super(key: key);

  final SettingLink setting;

  @override
  State<SettingLinkCard> createState() => _SettingLinkCardState();
}

class _SettingLinkCardState<T> extends State<SettingLinkCard> {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
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
    );
  }
}
