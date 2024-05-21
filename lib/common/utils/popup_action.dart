import 'package:clock_app/common/types/popup_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MenuAction getDeletePopupAction(
    BuildContext context, void Function() callback) {
  return MenuAction(
      AppLocalizations.of(context)!.deleteButton,
      (context) => callback(),
      Icons.delete_rounded,
      Theme.of(context).colorScheme.error);
}

MenuAction getDuplicatePopupAction(
    BuildContext context, void Function() callback) {
  return MenuAction(AppLocalizations.of(context)!.duplicateButton,
      (context) => callback(), Icons.copy_rounded);
}
