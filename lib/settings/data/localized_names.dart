  import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


String getLocalizedSettingName(String name, BuildContext context) {
  switch (name) {
    case "General":
      return AppLocalizations.of(context)!.generalSettingGroup;
    case "Appearance":
       return AppLocalizations.of(context)!.appearanceSettingGroup;
    default:
    return name;
  }
  }

String getLocalizedSettingDescription(String name, BuildContext context) {
  switch (name) {
    default:
    return name;
  }
  }
