import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/timer/types/timer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

class RingtonePlayer {
  static AudioPlayer? _alarmPlayer;
  static AudioPlayer? _timerPlayer;
  static AudioPlayer? activePlayer;
  static bool _vibratorIsAvailable = false;

  static Future<void> initialize() async {
    _alarmPlayer ??= AudioPlayer();
    _timerPlayer ??= AudioPlayer();
    _vibratorIsAvailable = (await Vibration.hasVibrator()) ?? false;
  }

  static void playUri(String ringtoneUri,
      {bool vibrate = false, LoopMode loopMode = LoopMode.one}) async {
    activePlayer = _alarmPlayer;
    _play(ringtoneUri, vibrate: vibrate, loopMode: LoopMode.one);
  }

  static void playAlarm(Alarm alarm, {LoopMode loopMode = LoopMode.one}) async {
    activePlayer = _alarmPlayer;
    _play(alarm.ringtoneUri,
        vibrate: alarm.vibrate,
        loopMode: LoopMode.one,
        secondsToMaxVolume: alarm.risingVolumeDuration.inSeconds);
  }

  static void playTimer(ClockTimer timer,
      {LoopMode loopMode = LoopMode.one}) async {
    activePlayer = _timerPlayer;
    _play(RingtoneManager.ringtones[0].uri,
        vibrate: true, loopMode: LoopMode.one);
  }

  static void _play(
    String ringtoneUri, {
    bool vibrate = false,
    LoopMode loopMode = LoopMode.one,
    int secondsToMaxVolume = 0,
  }) async {
    RingtoneManager.lastPlayedRingtoneUri = ringtoneUri;
    if (_vibratorIsAvailable && vibrate) {
      Vibration.vibrate(pattern: [500, 1000], repeat: 0);
    }
    await activePlayer?.stop();
    await activePlayer?.setAudioSource(AudioSource.uri(Uri.parse(ringtoneUri)));
    await activePlayer?.setLoopMode(loopMode);
    if (secondsToMaxVolume > 0) {
      for (int i = 0; i <= 10; i++) {
        Future.delayed(
          Duration(milliseconds: i * (secondsToMaxVolume * 100)),
          () {
            print("at time ${i * secondsToMaxVolume} set volume to ${i / 10}");
            activePlayer?.setVolume(i / 10);
          },
        );
      }
    }
    activePlayer?.play();

    // secondsToMaxVolume = 10
    // 0 - 0
    // 1 - 1000
    // 2 - 2000

    // secondsToMaxVolume = 5
    // 0 - 0
    // 1 - 500
    // 2 - 1000
  }

  static void pause() async {
    await activePlayer?.pause();
    if (_vibratorIsAvailable) {
      Vibration.cancel();
    }
  }

  static void stop() async {
    await activePlayer?.stop();
    if (_vibratorIsAvailable) {
      Vibration.cancel();
    }
    RingtoneManager.lastPlayedRingtoneUri = "";
  }
}
