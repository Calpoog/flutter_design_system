import 'package:flutter/material.dart';

/// A class for storing string values of global state that can be recalled with
/// URL changes.
///
/// Decorators and [Story] builders have access to globals. Values are stored
/// as strings for simplicity and most tools will use a map to turn the String
/// value into another type if need be (e.g. viewport name to a [Size]).
class Globals extends ChangeNotifier {
  /// Global name to value pairs
  Map<String, String> _values = {};

  /// Update or add all name/value pairs to the globals.
  void updateAll(Map<String, String> values) {
    _values.addAll(values);
    notifyListeners();
  }

  /// Remove a global by name.
  void remove(String name) {
    _values.remove(name);
    notifyListeners();
  }

  String? operator [](String name) {
    return _values[name];
  }

  void operator []=(String key, String value) {
    debugPrint('setting $key to $value');
    _values[key] = value;
    notifyListeners();
  }

  /// Replaces all global values. Used by routing to restore values from URL.
  void restore(Map<String, String> values) {
    _values = Map.of(values);
    notifyListeners();
  }

  /// An unmodifiable version of the globals name/value map.
  Map<String, String> all() {
    return Map.unmodifiable(_values);
  }
}
