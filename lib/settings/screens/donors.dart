import 'dart:convert';
import 'dart:math';

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
        title: AppLocalizations.of(context)!.donorsSetting,
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
                        DonorCard(contributor: contributor),
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

class DonorCard extends StatelessWidget {
  const DonorCard({
    super.key,
    required this.contributor,
  });

  final dynamic contributor;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final Color color =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return CardContainer(
      // onTap: () async {
      //   if (contributor['profile_url'] != null) {
      //     await launchUrl(
      //         Uri.parse(contributor['profile_url']));
      //   }
      // },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            CardContainer(
              color: color,
              alignment: Alignment.center,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(contributor['name'].substring(0, 1),
                      style: textTheme.headlineMedium?.copyWith(
                        color: color.computeLuminance() > 0.179
                            ? Colors.black
                            : Colors.white,
                      )),
                ),
              ),
            ),
            const SizedBox(width: 8),
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
    );
  }
}
