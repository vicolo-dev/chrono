import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:flutter/material.dart';

class MultiSelectFieldCard extends StatelessWidget {
  const MultiSelectFieldCard(
      {super.key, required this.title, required this.choices});

  final String title;
  final List<SelectChoice> choices;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textTheme.headlineMedium,
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onBackground.withOpacity(0.6))
          ],
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          width: MediaQuery.of(context).size.width - 64,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: [
              for (var i = 0; i < choices.length; i++)
                MultiSelectChip(choice: choices[i]),
            ],
          ),
        ),
      ],
    );
  }
}

class MultiSelectChip extends StatelessWidget {
  const MultiSelectChip({
    super.key,
    required this.choice,
  });

  final SelectChoice choice;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return CardContainer(
      key: Key(choice.name),
      color: colorScheme.primary,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Text(
          choice.name,
          style: const TextStyle(fontSize: 10)
              .copyWith(color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
