class SelectChoice<T> {
  final String description;
  final String name;
  final T value;

  const SelectChoice(
      {required this.value, required this.name, this.description = ""});
}
