// Library-consumer wrapper classes to abstract away library implementation things

import './models/arguments.dart' as a;
import './models/globals.dart' as g;

class Arguments {
  final a.Arguments _args;

  Arguments(this._args);

  T? value<T>(String name) {
    return _args.value<T>(name);
  }
}

class Globals {
  final g.Globals _globals;

  Globals(this._globals);

  String? value(String name) {
    return _globals[name];
  }
}
