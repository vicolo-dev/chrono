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
    _alarmPlayer ??= AudioPlayer(handleInterruptions: false);
    _timerPlayer ??= AudioPlayer(handleInterruptions: false);
    _mediaPlayer ??= AudioPlayer(handleInterruptions: false);
    _vibratorIsAvailable = (await Vibration.hasVibrator()) ?? false;
  }

  static Future<void> playUri(String ringtoneUri,
      {bool vibrate = false,
      LoopMode loopMode = LoopMode.one,
      AndroidAudioUsage channel = AndroidAudioUsage.media}) async {
    await initializeAudioSession(channel);
    activePlayer = _mediaPlayer;
    await _play(ringtoneUri, vibrate: vibrate, loopMode: LoopMode.one);
  }

  static Future<void> playAlarm(Alarm alarm,
      {LoopMode loopMode = LoopMode.one}) async {
    await initializeAudioSession(alarm.audioChannel);
    activePlayer = _alarmPlayer;
    await _play(
      alarm.ringtone.uri,
      vibrate: alarm.vibrate,
      loopMode: LoopMode.one,
      secondsToMaxVolume: alarm.risingVolumeDuration.inSeconds,
    );
  }

  static Future<void> playTimer(ClockTimer timer,
      {LoopMode loopMode = LoopMode.one}) async {
    await initializeAudioSession(timer.audioChannel);
    activePlayer = _timerPlayer;
    await _play(
      timer.ringtone.uri,
      vibrate: timer.vibrate,
      loopMode: LoopMode.one,
      secondsToMaxVolume: timer.risingVolumeDuration.inSeconds,
    );
  }

  static Future<void> _play(
    String ringtoneUri, {
    bool vibrate = false,
    LoopMode loopMode = LoopMode.one,
    int secondsToMaxVolume = 0,
  }) async {
    RingtoneManager.lastPlayedRingtoneUri = ringtoneUri;
    if (_vibratorIsAvailable && vibrate) {
      Vibration.vibrate(pattern: [500, 1000], repeat: 0);
    }
    // activePlayer?.
    await activePlayer?.stop();
    await activePlayer?.setLoopMode(loopMode);
    await activePlayer?.setAudioSource(AudioSource.uri(Uri.parse(ringtoneUri)));

    if (secondsToMaxVolume > 0) {
      for (int i = 0; i <= 10; i++) {
        Future.delayed(
          Duration(milliseconds: i * (secondsToMaxVolume * 100)),
          () {
            activePlayer?.setVolume(i / 10);
          },
        );
      }
    }
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
    if (_vibratorIsAvailable) {
      await Vibration.cancel();
    }
    RingtoneManager.lastPlayedRingtoneUri = "";
  }
}
