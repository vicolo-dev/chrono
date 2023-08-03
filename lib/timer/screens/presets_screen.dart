import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/timer/widgets/timer_preset_card.dart';
import 'package:clock_app/timer/widgets/timer_preset_picker.dart';
import 'package:flutter/material.dart';

class PresetsScreen extends StatefulWidget {
  const PresetsScreen({
    super.key,
  });

  @override
  State<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends State<PresetsScreen> {
  final _listController = PersistentListController<TimerPreset>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: Text("Edit Presets"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PersistentListView<TimerPreset>(
                  saveTag: 'timer_presets',
                  listController: _listController,
                  itemBuilder: (preset) => TimerPresetCard(
                    key: ValueKey(preset),
                    preset: preset,
                    onPressDelete: () => _listController.deleteItem(preset),
                  ),
                  onTapItem: (preset, index) async {
                    TimerPreset? newPreset = await showTimerPresetPicker(
                        context,
                        initialTimerPreset: preset);
                    if (newPreset == null) return;
                    _listController.changeItems((presets) {
                      presets[index] = newPreset;
                    });
                  },
                  // onDeleteItem: _handleDeleteTimer,
                  placeholderText: "No timers created",
                  reloadOnPop: true,
                ),
              ),
            ],
          ),
          FAB(
            bottomPadding: 8,
            onPressed: () async {
              TimerPreset? preset = await showTimerPresetPicker(context);
              if (preset == null) return;
              _listController.addItem(preset);
            },
          )
        ],
      ),
    );
  }
}
