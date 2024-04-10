class ListenerManager {
  static final Map<String, List<Function>> _listeners = {};

  static void addOnChangeListener(String key, Function listener) {
    final listeners = _listeners[key];
    if (listeners == null) {
      _listeners[key] = [listener];
    } else {
      if(listeners.contains(listener)) {
        return;
      }
      listeners.add(listener);
    }
  }

  static void removeOnChangeListener(String key, Function listener) {
    _listeners[key]?.remove(listener);
  }

  static void notifyListeners(String key) {
    _listeners[key]?.forEach((listener) => listener());
  }
}
