import 'package:clock_app/common/data/app_info.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/screens/licenses.dart';
import 'package:clock_app/settings/types/setting_link.dart';
import 'package:clock_app/settings/widgets/setting_page_link_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppTopBar(
        title: Text("About",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.6),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const AboutInfo(),
              SettingPageLinkCard(setting: SettingPageLink("Credits", const LicensesScreen())),
              //              CardContainer(
              //   child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Column(
              //         children: [
              //           Text(
              //             "Contributors",
              //             style: textTheme.headlineMedium?.copyWith(
              //               color: colorScheme.primary,
              //             ),
              //           ),
              //           // Image.network(
              //           //     "https://avatars.githubusercontent.com/u/41967492?v=4"),
              //         ],
              //       )),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class AboutInfo extends StatelessWidget {
  const AboutInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: CardContainer(
                      child: Image.asset('assets/images/logo.png')),
                ),
                const SizedBox(width: 16.0),
                Text(
                  packageInfo?.appName ?? 'Chrono',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Version",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      packageInfo?.version ?? '1.0.0',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Icon(
                    Icons.center_focus_weak_rounded,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package name",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      packageInfo?.packageName ?? 'com.vicolo.chrono',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            InkWell(
              onTap: () async {
                await launchUrl(Uri.parse(
                    "https://github.com/vicolo-dev/chrono/blob/master/LICENSE"));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Icon(
                      Icons.balance_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "License",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'GNU GPL v3.0',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            InkWell(
              onTap: () async {
                String mailUrl = 'mailto:ahsansarwar.as45@gmail.com';
                try {
                  await launchUrlString(mailUrl);
                } catch (e) {
                  Clipboard.setData(
                      const ClipboardData(text: "ahsansarwar.as45@gmail.com"));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Email copied to clipboard")));
                  }
                }
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Icon(
                      Icons.mail_outline_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "ahsansarwar.as45@gmail.com",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            InkWell(
              onTap: () async {
                await launchUrl(
                    Uri.parse("https://github.com/vicolo-dev/chrono"));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Icon(
                      Icons.code_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    "View on Github",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
