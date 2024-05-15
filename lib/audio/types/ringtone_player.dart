import 'package:audio_session/audio_session.dart';
import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class RingtonePlayer {
  static AudioPlayer? _alarmPlayer;
  static AudioPlayer? _timerPlayer;
  static AudioPlayer? _mediaPlayer;
  static AudioPlayer? activePlayer;
  static bool _vibratorIsAvailable = false;

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
    // await initializeAudioSession(channel);
    activePlayer = _mediaPlayer;
    await _play(ringtoneUri, vibrate: vibrate, loopMode: LoopMode.one);
  }

  static Future<void> playAlarm(Alarm alarm,
      {LoopMode loopMode = LoopMode.one}) async {
    print(
        "******************** ${alarm.audioChannel.value} *******************");
    await activePlayer?.stop();
    // await initializeAudioSession(alarm.audioChannel);
    _alarmPlayer = AudioPlayer(handleInterruptions: false);
    await _alarmPlayer?.setAndroidAudioAttributes(AndroidAudioAttributes(
      usage: alarm.audioChannel,
      contentType: AndroidAudioContentType.music,
    ));
    activePlayer = _alarmPlayer;
    String uri = alarm.ringtone.uri;
    // if (alarm.ringtone.type == FileItemType.directory) {
    //   print(alarm.ringtone.uri);
    //   List<String>? persistentPermUris =
    //       await PickOrSave().urisWithPersistedPermission();
    //   print(persistentPermUris);
    // print(await Directory(alarm.ringtone.uri).list(recursive: true).toList());
    // List<DocumentFile>? documentFiles =
    //     await PickOrSave().directoryDocumentsPicker(
    //   params: DirectoryDocumentsPickerParams(
    //     directoryUri: alarm.ringtone.uri,
    //     // recurseDirectories: true,
    //     mimeTypesFilter: ["audio/*"],
    //   ),
    // );
    // if (documentFiles != null && documentFiles.isNotEmpty) {
    //   Random random = Random();
    //   int index = random.nextInt(documentFiles.length);
    //   DocumentFile documentFile = documentFiles[index];
    //   print("${documentFile.name} ${documentFile.uri}");
    //   uri = documentFile.uri;
    // } else {
    //   // Choose a default ringtone if directory doesn't have any audio
    //   uri = (await loadList<FileItem>("ringtones"))
    //       .where((ringtone) => ringtone.type == FileItemType.audio)
    //       .toList()
    //       .first
    //       .uri;
    // }
    // }
    await _play(
      uri,
      vibrate: alarm.vibrate,
      loopMode: LoopMode.one,
      volume: alarm.volume / 100,
      secondsToMaxVolume: alarm.risingVolumeDuration.inSeconds,
    );
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
    await activePlayer?.setVolume(volume);
  }

  static Future<void> _play(
    String ringtoneUri, {
    bool vibrate = false,
    LoopMode loopMode = LoopMode.one,
    double volume = 1.0,
    int secondsToMaxVolume = 0,
    // double duration = double.infinity,
  }) async {
    RingtoneManager.lastPlayedRingtoneUri = ringtoneUri;
    if (_vibratorIsAvailable && vibrate) {
      Vibration.vibrate(pattern: [500, 1000], repeat: 0);
    }
    // activePlayer?.
    await activePlayer?.stop();
    await activePlayer?.setLoopMode(loopMode);
    await activePlayer?.setAudioSource(AudioSource.uri(Uri.parse(ringtoneUri)));
    await activePlayer?.setVolume(volume);
    // activePlayer.setMode

    if (secondsToMaxVolume > 0) {
      for (int i = 0; i <= 10; i++) {
        Future.delayed(
          Duration(milliseconds: i * (secondsToMaxVolume * 100)),
          () {
            activePlayer?.setVolume((i / 10) * volume);
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
  }
}
