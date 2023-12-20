import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/fields/select_field/option_cards/audio_option_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/option_cards/color_option_card.dart';
import 'package:clock_app/common/widgets/fields/select_field/option_cards/text_option_card.dart';
import 'package:flutter/material.dart';

class SelectBottomSheet extends StatelessWidget {
  const SelectBottomSheet({
    super.key,
    required this.title,
    this.description,
    required this.choices,
    required this.currentSelectedIndex,
    required this.onSelect,
  });

  final String title;
  final String? description;
  final List<SelectChoice> choices;
  final int currentSelectedIndex;
  final void Function(int) onSelect;

  Widget _getOptionCard() {
    if (choices[0].value is Color) {
      return GridView.builder(
        itemCount: choices.length,
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index) {
          return SelectColorOptionCard(
            index: index,
            choice: choices[index],
            selectedIndex: currentSelectedIndex,
            onSelect: onSelect,
          );
        },
      );
    }

    if (choices[0].value is FileItem) {
      return ListView.builder(
          itemCount: choices.length,
          itemBuilder: (context, index) {
            return SelectAudioOptionCard(
              index: index,
              choice: choices[index],
              selectedIndex: currentSelectedIndex,
              onSelect: onSelect,
            );
          });
    }

    return ListView.builder(
        itemCount: choices.length,
        itemBuilder: (context, index) {
          return SelectTextOptionCard(
            index: index,
            choice: choices[index],
            selectedIndex: currentSelectedIndex,
            onSelect: onSelect,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    BorderRadiusGeometry borderRadius = theme.cardTheme.shape != null
        ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
        : BorderRadius.circular(8.0);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            SizedBox(
              height: 4.0,
              width: 48,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    color: colorScheme.onSurface.withOpacity(0.6)),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6)),
                  ),
                  if (description != null) const SizedBox(height: 8.0),
                  if (description != null)
                    Text(
                      description!,
                      style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: _getOptionCard(),
            )
          ],
        ),
      ),
    );
  }
}
