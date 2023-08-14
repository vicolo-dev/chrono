import 'package:flutter/material.dart';

enum CardAction { duplicate, delete }

class CardEditMenu extends StatelessWidget {
  const CardEditMenu({
    super.key,
    this.onPressDelete,
    this.onPressDuplicate,
  });

  final VoidCallback? onPressDelete;
  final VoidCallback? onPressDuplicate;
  // final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return PopupMenuButton<CardAction>(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurface,
      ),
      padding: EdgeInsets.zero,
      onSelected: (CardAction action) {
        switch (action) {
          case CardAction.duplicate:
            onPressDuplicate?.call();
            break;
          case CardAction.delete:
            onPressDelete?.call();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CardAction>>[
        if (onPressDuplicate != null)
          const PopupMenuItem<CardAction>(
            value: CardAction.duplicate,
            child:
                CardEditMenuItem(icon: Icons.copy_rounded, text: 'Duplicate'),
          ),
        if (onPressDelete != null)
          PopupMenuItem<CardAction>(
            value: CardAction.delete,
            child: CardEditMenuItem(
                icon: Icons.delete, text: 'Delete', color: colorScheme.error),
          ),
      ],
    );
  }
}

class CardEditMenuItem extends StatelessWidget {
  const CardEditMenuItem(
      {Key? key, required this.icon, required this.text, this.color})
      : super(key: key);

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    Color itemColor = color ?? colorScheme.onBackground;
    return Row(children: [
      Icon(icon, color: itemColor),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(color: itemColor)),
    ]);
  }
}
