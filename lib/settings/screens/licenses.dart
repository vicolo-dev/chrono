import 'package:clock_app/common/data/app_info.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/oss_licenses.dart';
import 'package:clock_app/settings/types/setting_action.dart';
import 'package:clock_app/settings/widgets/setting_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppTopBar(
        title: Text("Credits",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.6),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              ...allDependencies.map((dependency) => SettingActionCard(
                      setting: SettingAction(dependency.name, (context) async {
                    if (dependency.repository != null) {
                      await launchUrl(Uri.parse(dependency.repository!));
                    }
                  }))),
            ],
          ),
        ),
      ),
    );
  }
}
