import 'package:clock_app/common/types/list_filter.dart';
import 'package:flutter/material.dart';

class ActionBottomSheet extends StatelessWidget {
  const ActionBottomSheet({
    super.key,
    required this.title,
    required this.actions,
    this.description,
  });

  final String title;
  final String? description;
  final List<ListFilterAction> actions;

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
              child: ListView.builder(
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await actions[index].action();
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Icon(actions[index].icon,
                                  color: actions[index].color ??
                                      colorScheme.primary),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 999,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(actions[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                color: actions[index].color)),
                                    // if (choice.description.isNotEmpty) ...[
                                    //   const SizedBox(height: 4.0),
                                    //   Text(
                                    //     choice.description,
                                    //     style: Theme.of(context).textTheme.bodyMedium,
                                    //     maxLines: 5,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     softWrap: true,
                                    //   )
                                    // ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            // if (multiSelect) const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
