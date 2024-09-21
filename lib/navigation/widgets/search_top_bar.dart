import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchParams<T> {
  final void Function(List<T> filteredItems)? onSearch;
  final List<T> choices;
  final String Function(T)? searchTermGetter;
  final String placeholder;

  SearchParams(
      {required this.onSearch,
      required this.placeholder,
      required this.choices,
      required this.searchTermGetter});
}

class SearchTopBar<T> extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size(0, 56);

  const SearchTopBar({super.key, this.title, this.actions, this.searchParams});

  final SearchParams<T>? searchParams;
  final List<Widget>? actions;
  final String? title;

  @override
  State<SearchTopBar<T>> createState() => _SearchTopBarState<T>();
}

class _SearchTopBarState<T> extends State<SearchTopBar<T>> {
  final TextEditingController _filterController = TextEditingController();
  bool _searching = false;

  _SearchTopBarState() {
    _filterController.addListener(() async {
      if (widget.searchParams == null) {
        return;
      }
      if (_filterController.text.isEmpty) {
        widget.searchParams!.onSearch?.call([]);
      } else {
        var results = extractTop<T>(
          query: _filterController.text,
          choices: widget.searchParams!.choices,
          // choices: [
          //   ...appSettings.settings,
          //   ...appSettings.settingPageLinks,
          //   ...appSettings.settingActions
          // ],
          limit: 10,
          cutoff: 50,
          getter: widget.searchParams!.searchTermGetter,
          // getter: (item) {
          //   // Search term includes the setting name, as well as the parent group names
          //   return "${item.name} ${item.path.map((group) => group.name).join(" ")} ${item.searchTags.join(" ")}";
          // },
        );

        widget.searchParams!.onSearch
            ?.call(results.map((result) => result.choice).toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    if (_searching) {
      return AppTopBar(
        titleWidget: Expanded(
          child: TextField(
            autofocus: _filterController.text.isEmpty,
            onTapOutside: ((event) {
              FocusScope.of(context).unfocus();
            }),
            controller: _filterController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Colors.transparent,
              hintText: widget.searchParams!.placeholder,
              hintStyle: textTheme.bodyLarge,
            ),
            textAlignVertical: TextAlignVertical.center,
            style: textTheme.bodyLarge,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _filterController.clear();
              setState(() {
                _searching = false;
              });
            },
            icon: const Icon(Icons.close),
          )
        ],
      );
    } else {
      return AppTopBar(
        title: widget.title,
        actions: [
          ...?widget.actions,
          if (widget.searchParams != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _searching = true;
                });
              },
              icon: Icon(
                Icons.search,
                color: colorScheme.onBackground,
              ),
            )
        ],
      );
    }
  }
}
