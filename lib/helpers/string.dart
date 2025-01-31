extension StringExtension on String {
  bool isAlphabet() {
    return RegExp(r'^[a-zA-Z]$').hasMatch(this);
  }

  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String capitalizeAll() {
    return split(' ').map((e) => e.capitalize()).join(' ');
  }
}
