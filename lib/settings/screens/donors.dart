import 'dart:convert';

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<dynamic> readDonors() async {
  final String response =
      await rootBundle.loadString('assets/patreons/patreons.json');
  return await json.decode(response);
}

class DonorsScreen extends StatelessWidget {
  DonorsScreen({super.key});
  final Future<dynamic> donors = readDonors();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppTopBar(
        title: Text(AppLocalizations.of(context)!.donorsSetting,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.6),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FutureBuilder<dynamic>(
              future: donors,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dynamic contributors = snapshot.data!;
                  return Column(
                    children: [
                      for (final contributor in contributors)
                        CardContainer(
                          // onTap: () async {
                          //   if (contributor['profile_url'] != null) {
                          //     await launchUrl(
                          //         Uri.parse(contributor['profile_url']));
                          //   }
                          // },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                // CardContainer(
                                //   child: Image(
                                //     width: 48,
                                //     image:
                                //         AssetImage(contributor['name']),
                                //   ),
                                // ),
                                // const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    contributor['name'],
                                    style: textTheme.headlineMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
      ),
    );
  }
}
