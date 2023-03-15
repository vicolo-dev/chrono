class ListenerManager {
  static final Map<String, List<void Function()>> _listeners = {};

  static void addOnChangeListener(String key, void Function() listener) {
    final listeners = _listeners[key];
    if (listeners == null) {
      _listeners[key] = [listener];
    } else {
      listeners.add(listener);
    }
  }

  static void removeOnChangeListener(String key, void Function() listener) {
    _listeners[key]?.remove(listener);
  }

  static void notifyListeners(String key) {
    _listeners[key]?.forEach((listener) => listener());
  }
}
