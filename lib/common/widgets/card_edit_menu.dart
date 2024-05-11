import 'package:clock_app/common/types/popup_action.dart';
import 'package:flutter/material.dart';

// enum CardAction { duplicate, delete }

class CardEditMenu extends StatelessWidget {
  const CardEditMenu({
    super.key,
    required this.actions,
  });

  final List<MenuAction> actions;
  // final GlobalKey _buttonKey = GlobalKey();

  List<PopupMenuEntry<String>> getItems() {
    List<PopupMenuEntry<String>> items = [];
    for (var action in actions) {
      items.add(PopupMenuItem(
        value: action.name,
        child: CardEditMenuItem(
            icon: action.icon, text: action.name, color: action.color),
      ));
    }
    return items;
  }

  void onSelected(BuildContext context, String action) {
    for (var item in actions) {
      if (item.name == action) {
        item.action(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurface,
      ),
      padding: EdgeInsets.zero,
      onSelected: (action) => onSelected(context, action),
      itemBuilder: (BuildContext context) => getItems(),
    );
  }
}

class CardEditMenuItem extends StatelessWidget {
  const CardEditMenuItem(
      {super.key, required this.icon, required this.text, this.color});

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
