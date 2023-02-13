import 'package:clock_app/common/types/select_choice.dart';
import 'package:clock_app/common/widgets/select_option_card.dart';
import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/color.dart';
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          SizedBox(
            height: 4.0,
            width: 48,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: defaultBorderRadius,
                  color: ColorTheme.textColorTertiary),
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorTheme.textColorSecondary),
                ),
                if (description != null) const SizedBox(height: 8.0),
                if (description != null)
                  Text(
                    description!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: ColorTheme.textColorSecondary),
                  ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: choices.length,
              itemBuilder: (context, index) {
                return SelectOptionCard(
                  index: index,
                  choice: choices[index],
                  selectedIndex: currentSelectedIndex,
                  onSelect: onSelect,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
