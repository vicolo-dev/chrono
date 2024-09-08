class QuickActionController {
  Function(String name)? _action;

  void setAction(Function(String name)? action) {
    _action = action;
  }

  void callAction(String name) {
    _action?.call(name);
  }
}
