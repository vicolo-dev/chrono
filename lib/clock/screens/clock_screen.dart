import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:great_list_view/great_list_view.dart';

import 'package:clock_app/clock/screens/search_city_screen.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_card.dart';
import 'package:clock_app/common/utils/reorderable_list_decorator.dart';
import 'package:clock_app/common/widgets/clock.dart';
import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/navigation/types/alignment.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  List<City> _cities = [];
  bool shouldShowSeconds = false;

  final _scrollController = ScrollController();
  final _controller = AnimatedListController();

  void setShowSeconds(dynamic value) {
    setState(() {
      shouldShowSeconds = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() => _cities = loadList('favorite_cities'));
    setShowSeconds(appSettings.getSetting("Show Seconds").value);
    appSettings.addSettingListener("Show Seconds", setShowSeconds);
  }

  @override
  void dispose() {
    appSettings.removeSettingListener("Show Seconds", setShowSeconds);
    super.dispose();
  }

  _handleSearchReturn(dynamic city) {
    if (city != null) {
      _cities.add(city);
    }
    _controller.notifyInsertedRange(_cities.length - 1, 1);

    saveList('favorite_cities', _cities);
  }

  _handleDeleteCity(City deletedCity) {
    int index = _cities.indexWhere((city) => city.id == deletedCity.id);
    _cities.removeAt(index);
    _controller.notifyRemovedRange(
      index,
      1,
      (context, index, data) => data.measuring
          ? const SizedBox(height: 64)
          : TimeZoneCard(
              key: ValueKey(deletedCity),
              city: deletedCity,
              onDelete: () => {},
            ),
    );

    saveList('favorite_cities', _cities);
  }

  bool _handleReorderCities(int oldIndex, int newIndex, Object? slow) {
    _cities.insert(newIndex, _cities.removeAt(oldIndex));
    saveList('favorite_cities', _cities);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Clock(
            shouldShowDate: true,
            shouldShowSeconds: shouldShowSeconds,
            horizontalAlignment: ElementAlignment.center,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: AutomaticAnimatedListView<City>(
              list: _cities,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              comparator: AnimatedListDiffListComparator<City>(
                sameItem: (a, b) => a.id == b.id,
                sameContent: (a, b) => a.id == b.id,
              ),
              itemBuilder: (BuildContext context, city, data) {
                return data.measuring
                    ? const SizedBox(height: 64)
                    : TimeZoneCard(
                        key: ValueKey(city),
                        city: city,
                        onDelete: () => _handleDeleteCity(city),
                      );
              },
              listController: _controller,
              scrollController: _scrollController,
              addLongPressReorderable: true,
              reorderModel: AnimatedListReorderModel(
                onReorderStart: (index, dx, dy) => true,
                onReorderFeedback: (int index, int dropIndex, double offset,
                        double dx, double dy) =>
                    null,
                onReorderMove: (int index, int dropIndex) => true,
                onReorderComplete: _handleReorderCities,
              ),
              reorderDecorationBuilder: reorderableListDecorator,
              footer: const SizedBox(height: 64),
            ),
          ),
        ),
      ]),
      FAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchCityScreen()),
          ).then(_handleSearchReturn);
        },
      )
    ]);
  }
}
