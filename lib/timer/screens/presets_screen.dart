import 'package:clock_app/common/widgets/fab.dart';
import 'package:clock_app/common/widgets/list/persistent_list_view.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/timer/types/timer_preset.dart';
import 'package:clock_app/timer/widgets/timer_preset_card.dart';
import 'package:clock_app/timer/widgets/timer_preset_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar: AppTopBar(
        titleWidget: Text(
          AppLocalizations.of(context)!.editPresetsTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
        ),
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
                    onPressDuplicate: () =>
                        _listController.duplicateItem(preset),
                  ),
                  onTapItem: (preset, index) async {
                    TimerPreset? newPreset = await showTimerPresetPicker(
                        context,
                        initialTimerPreset: preset);
                    if (newPreset == null) return;
                    preset.copyFrom(newPreset);
                    _listController.changeItems((presets) {});
                  },
                  // onDeleteItem: _handleDeleteTimer,
                  placeholderText: "No presets created",
                  reloadOnPop: true,
                  isSelectable: true,
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
