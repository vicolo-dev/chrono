import 'package:flutter/material.dart';

Future<bool?> showDeleteAlertDialogue(BuildContext context) async {
  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;
  return await showDialog<bool>(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 6, right: 10),
          content: const Text("Do you want to delete all filtered items?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No", style: TextStyle(color: colorScheme.primary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Yes", style: TextStyle(color: colorScheme.error)),
            ),
          ],
        );
      });
}
