
import 'package:clock_app/alarm/types/alarm_event.dart';
import 'package:clock_app/alarm/widgets/alarm_event_card.dart';
import 'package:clock_app/common/types/list_filter.dart';
import 'package:clock_app/common/utils/date_time.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/types/setting_item.dart';
import 'package:flutter/material.dart';

class AlarmEventsScreen extends StatefulWidget {
  const AlarmEventsScreen({
    super.key,
  });

  @override
  State<AlarmEventsScreen> createState() => _AlarmEventsScreenState();
}

final List<ListFilter<AlarmEvent>> alarmEventsListFilters = [
  ListFilter(
    'All',
    (event) => true,
  ),
   ListFilter(
    'Active',
    (event) {
      return event.isActive;
    },
  ),
  ListFilter('Tomorrow', (event) {
   return event.startDate.isTomorrow();
  }),

  ListFilter(
    'Today',
    (event) {
      return event.startDate.isToday();
    },
  ),
  ListFilter('Tomorrow', (event) {
   return event.startDate.isTomorrow();
  }),

];

class _AlarmEventsScreenState extends State<AlarmEventsScreen> {
  final _listController = PersistentListController<AlarmEvent>();
  List<SettingItem> searchedItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppTopBar(title: Text("Alarm Logs", style: textTheme.titleMedium)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: PersistentListView<AlarmEvent>(
                  saveTag: 'alarm_events',
                  listController: _listController,
                  itemBuilder: (event) => AlarmEventCard(
                    key: ValueKey(event),
                    event: event,
                  ),
                  // onTapItem: (fileItem, index) {
                  //   // widget.setting.setValue(context, themeItem);
                  //   // _listController.reload();
                  // },
                  isDuplicateEnabled: false,
                  placeholderText: "No alarm events",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            icon: Icons.delete_rounded,
            bottomPadding: 8,
            onPressed: () async {
              _listController.clearItems();
              setState(() {});
                          
                        },
          ),
          // FAB(
          //   index: 1,
          //   icon: Icons.folder_rounded,
          //   bottomPadding: 8,
          //   onPressed: () async {
          //     // Item? themeItem = widget.createThemeItem();
          //     // await _openCustomizeItemScreen(
          //     //   themeItem,
          //     //   onSave: (newThemeItem) {
          //     //     _listController.addItem(newThemeItem);
          //     //   },
          //     //   isNewItem: true,
          //     // );
          //   },
          // )
        ],
      ),
    );
  }
}
