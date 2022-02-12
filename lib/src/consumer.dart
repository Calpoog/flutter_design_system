// Library-consumer wrapper classes to abstract away library implementation things

import './models/arguments.dart' as a;
import './models/globals.dart' as g;

/// An object to access arg values given to a [Story], either by its definition
/// or after it has been modified by a control.
class Arguments {
  final a.Arguments _args;

  /// Creates Arguments.
  Arguments(this._args);

  /// Get the value of the arg with the given [name]
  ///
  /// A specific type can be returned by using the generic `<T>`
  T? value<T>(String name) {
    return _args.value<T>(name);
  }
}

/// Global values set by tools which can be accessed in [Story] builders and
/// [Decorator]s.
class Globals {
  final g.Globals _globals;

  /// Creates Globals.
  Globals(this._globals);

  /// Get the value of the global with the given [name]
  String? value(String name) {
    return _globals[name];
  }
}
