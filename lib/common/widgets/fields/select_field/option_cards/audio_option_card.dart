import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';
import 'package:clock_app/common/types/select_choice.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SelectAudioOptionCard extends StatefulWidget {
  const SelectAudioOptionCard({
    Key? key,
    required this.selectedIndex,
    required this.choice,
    required this.index,
    required this.onSelect,
  }) : super(key: key);

  final int selectedIndex;
  final SelectChoice choice;
  final int index;
  final void Function(int) onSelect;

  @override
  State<SelectAudioOptionCard> createState() => _SelectAudioOptionCardState();
}

class _SelectAudioOptionCardState extends State<SelectAudioOptionCard> {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    RingtoneManager.addListener(_updateIsPlaying);
    _updateIsPlaying();
  }

  @override
  void dispose() {
    RingtoneManager.removeListener(_updateIsPlaying);
    super.dispose();
  }

  void _updateIsPlaying() {
    setState(() {
      isPlaying =
          RingtoneManager.lastPlayedRingtoneUri == widget.choice.value.uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onSelect(widget.index),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: widget.choice.description.isNotEmpty ? 8.0 : 2.0),
          child: Row(
            children: [
              Radio(
                value: widget.index,
                groupValue: widget.selectedIndex,
                onChanged: (dynamic value) => widget.onSelect(widget.index),
              ),
              Expanded(
                flex: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Flutter doesn't allow per character overflow, so this is a workaround
                      widget.choice.value.name,
                      style: textTheme.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    if (widget.choice.description.isNotEmpty)
                      const SizedBox(height: 4.0),
                    if (widget.choice.description.isNotEmpty)
                      Text(widget.choice.description,
                          style: textTheme.bodyMedium),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () async {
                    if (RingtoneManager.lastPlayedRingtoneUri ==
                        widget.choice.value.uri) {
                      await RingtonePlayer.stop();
                      _updateIsPlaying();
                    } else {
                      await RingtonePlayer.playUri(widget.choice.value.uri,
                          loopMode: LoopMode.off);
                      _updateIsPlaying();
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: colorScheme.primary,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
