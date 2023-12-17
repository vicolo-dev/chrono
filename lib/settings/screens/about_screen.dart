import 'package:clock_app/common/data/app_info.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              CardContainer(
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
                              color: colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const SizedBox(
                            width: 48,
                            child: Icon(
                              Icons.info_outline_rounded,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Version",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onBackground,
                                ),
                              ),
                              Text(
                                packageInfo?.version ?? '1.0.0',
                                style: textTheme.bodyMedium?.copyWith(
                                  color:
                                      colorScheme.onBackground.withOpacity(0.6),
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
                              "https://github.com/vicolo-dev/chrono"));
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 48,
                              child: Icon(
                                Icons.code_rounded,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
