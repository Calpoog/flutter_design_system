import 'package:flutter/material.dart';

abstract class UsesGlobals extends ChangeNotifier {
  final String namespace;

  UsesGlobals(this.namespace);

  // Serializes the value pairs for the URL
  Map<String, String> serialize();

  deserialize(Map<String, String> serialized);
}

/// A class for storing string values of global state like viewport, zoom,
/// and theme that can be recalled with URL changes.
class Globals extends ChangeNotifier {
  /// Map of user namespace to the values to persist
  final Map<String, Map<String, String>> _values = {};

  /// Map of globals users to namespace
  final Map<UsesGlobals, String> _users = {};

  register(UsesGlobals user) {
    _users[user] = user.namespace;

    final serialized = _values[user.namespace];
    if (serialized != null) user.deserialize(serialized);
  }

  unregister(UsesGlobals user) {
    _users.remove(user);
    _values.remove(user.namespace);
  }

  update(UsesGlobals user) {
    _values[user.namespace] = user.serialize();
    notifyListeners();
  }

  restore(Map<String, String> values) {
    _values.clear();
    for (final key in values.keys) {
      final name = key.split('.');
      if (name.length == 2) {
        if (_values[name[0]] == null) {
          _values[name[0]] = {};
        }
        _values[name[0]]![name[1]] = values[key]!;
      }
    }
    _users.forEach((user, namespace) {
      user.deserialize(_values[namespace] ?? {});
    });
  }

  Map<String, String> serialize() {
    final Map<String, String> serialized = {};

    _values.forEach((namespace, values) {
      values.forEach((key, value) {
        serialized['$namespace.$key'] = value;
      });
    });

    return serialized;
  }
}
