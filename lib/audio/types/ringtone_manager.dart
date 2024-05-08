class RingtoneManager {
    static String _lastPlayedRingtoneUri = "";

  static final List<void Function()> _listeners = [];

  static List<void Function()> get listeners => _listeners;
  static String get lastPlayedRingtoneUri => _lastPlayedRingtoneUri;
  static set lastPlayedRingtoneUri(String uri) {
    _lastPlayedRingtoneUri = uri;
    for (var listener in _listeners) {
      listener();
    }
  }

  static void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  static void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }
}
