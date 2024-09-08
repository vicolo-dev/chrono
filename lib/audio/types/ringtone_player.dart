import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/types/file_item.dart';
import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:vibration/vibration.dart';

Random random = Random();

class RingtonePlayer {
  static AudioPlayer? _alarmPlayer;
  static AudioPlayer? _timerPlayer;
  static AudioPlayer? _mediaPlayer;
  static AudioPlayer? activePlayer;
  static bool _vibratorIsAvailable = false;
  static bool _stopRisingVolume = false;

  static Future<void> initialize() async {
    _alarmPlayer ??= AudioPlayer(handleInterruptions: true);
    _timerPlayer ??= AudioPlayer(handleInterruptions: true);
    _mediaPlayer ??= AudioPlayer(handleInterruptions: true);
    _mediaPlayer?.setAndroidAudioAttributes(
      const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
    );
    _vibratorIsAvailable = (await Vibration.hasVibrator()) ?? false;
  }

  static Future<void> playUri(String ringtoneUri,
      {bool vibrate = false,
      LoopMode loopMode = LoopMode.one,
      AndroidAudioUsage channel = AndroidAudioUsage.alarm}) async {
    activePlayer = _mediaPlayer;
    await _play(ringtoneUri, vibrate: vibrate, loopMode: LoopMode.one);
  }

  static Future<String> getDefaultRingtoneUri() async {
    return (await loadList<FileItem>("ringtones"))
        .firstWhere((ringtone) => ringtone.type == FileItemType.audio)
        .uri;
  }

  static Future<String> getRingtoneUri(Alarm alarm) async {
    switch (alarm.ringtone.type) {
      case FileItemType.directory:
        try {
          logger.t(alarm.ringtone.uri);
          // logger.t(
          //     await Directory(alarm.ringtone.uri).list(recursive: true).toList());
          List<DocumentFile>? documentFiles =
              await PickOrSave().directoryDocumentsPicker(
            params: DirectoryDocumentsPickerParams(
              directoryUri: alarm.ringtone.uri,
              // recurseDirectories: true,
              mimeTypesFilter: ["audio/*"],
            ),
          );
          if (documentFiles != null && documentFiles.isNotEmpty) {
            logger.t("Audio files found in directory ${alarm.ringtone.uri}");
            Random random = Random();
            int index = random.nextInt(documentFiles.length);
            DocumentFile documentFile = documentFiles[index];
            logger.t("${documentFile.name} ${documentFile.uri}");
            return documentFile.uri;
          } else {
            logger.t(
                "No audio files found in directory ${alarm.ringtone.uri}, using default");
            // Choose a default ringtone if directory doesn't have any audio
            return await getDefaultRingtoneUri();
          }
        } catch (e) {
          logger.e("Error loading melody from directory: $e");
          return await getDefaultRingtoneUri();
        }

      case FileItemType.audio:
        return alarm.ringtone.uri;

      default:
        return await getDefaultRingtoneUri();
    }
  }

  static Future<void> playAlarm(Alarm alarm,
      {LoopMode loopMode = LoopMode.one}) async {
    await activePlayer?.stop();
    _alarmPlayer = AudioPlayer(handleInterruptions: false);
    await _alarmPlayer?.setAndroidAudioAttributes(AndroidAudioAttributes(
      usage: alarm.audioChannel,
      contentType: AndroidAudioContentType.music,
    ));
    activePlayer = _alarmPlayer;
    String uri = await getRingtoneUri(alarm);

    logger.t("Playing alarm with uri: $uri");

    await _play(uri,
        vibrate: alarm.vibrate,
        loopMode: LoopMode.one,
        volume: alarm.volume / 100,
        secondsToMaxVolume: alarm.risingVolumeDuration.inSeconds,
        startAtRandomPos: alarm.shouldStartMelodyAtRandomPos);
  }

  static Future<void> playTimer(ClockTimer timer,
      {LoopMode loopMode = LoopMode.one}) async {
    await _timerPlayer?.setAndroidAudioAttributes(AndroidAudioAttributes(
      usage: timer.audioChannel,
      contentType: AndroidAudioContentType.music,
    ));
    activePlayer = _timerPlayer;
    await _play(
      timer.ringtone.uri,
      vibrate: timer.vibrate,
      loopMode: LoopMode.one,
      volume: timer.volume / 100,
      secondsToMaxVolume: timer.risingVolumeDuration.inSeconds,
    );
  }

  static Future<void> setVolume(double volume) async {
    logger.t("Setting volume to $volume");
    _stopRisingVolume = true;
    await activePlayer?.setVolume(volume);
  }

  static Future<void> _play(
    String ringtoneUri, {
    bool vibrate = false,
    LoopMode loopMode = LoopMode.one,
    double volume = 1.0,
    int secondsToMaxVolume = 0,
    bool startAtRandomPos = false,
    // double duration = double.infinity,
  }) async {
    try {
      _stopRisingVolume = false;

      RingtoneManager.lastPlayedRingtoneUri = ringtoneUri;
      if (_vibratorIsAvailable && vibrate) {
        Vibration.vibrate(pattern: [500, 1000], repeat: 0);
      }
      // activePlayer?.
      await activePlayer?.stop();
      await activePlayer?.setLoopMode(loopMode);
      Duration? duration = await activePlayer
          ?.setAudioSource(AudioSource.uri(Uri.parse(ringtoneUri)));
      logger.t("Duration: $duration");

      if (duration != null && startAtRandomPos) {
        double randomNumber = random.nextInt(100) / 100.0;
        logger.t("Starting at random position: $randomNumber");
        activePlayer?.seek(duration * randomNumber);
      }
      await setVolume(volume);

      // Gradually increase the volume
      if (secondsToMaxVolume > 0) {
        for (int i = 0; i <= 10; i++) {
          Future.delayed(
            Duration(milliseconds: i * (secondsToMaxVolume * 100)),
            () {
              if (!_stopRisingVolume) {
                setVolume((i / 10) * volume);
              }
            },
          );
        }
      }
      // Future.delayed(
      //   Duration(seconds: duration.toInt()),
      //   () async {
      //     await stop();
      //   },
      // );

      // Don't use await here as this will only return after the audio is done
      activePlayer?.play();
    } catch (e) {
      logger.e("Error playing $ringtoneUri: $e");
    }
  }

  static Future<void> pause() async {
    await activePlayer?.pause();
    if (_vibratorIsAvailable) {
      await Vibration.cancel();
    }
  }

  static Future<void> stop() async {
    await activePlayer?.stop();
    final session = await AudioSession.instance;
    await session.setActive(false);
    if (_vibratorIsAvailable) {
      await Vibration.cancel();
    }
    RingtoneManager.lastPlayedRingtoneUri = "";
    _stopRisingVolume = false;
  }
}
