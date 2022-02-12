import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'arg_type.dart';
import 'story.dart';
import '../routing/router_delegate.dart';

class Arguments extends ChangeNotifier {
  late Story _story;
  late ArgTypes _argTypes;
  late final AppState? _appState;
  bool isForced = true;

  Arguments({required Story story, BuildContext? context}) {
    _appState = context?.read<AppState>();
    updateStory(story);
    _appState?.addListener(_stateListener);
  }

  _stateListener() {
    if (_appState!.isRestoring) {
      isForced = true;
      notifyListeners();
    }
  }

  T? value<T>(String name) {
    final values = _story.args;
    assert(_argTypes.containsKey(name), 'There is no arg definition \'$name\'');
    ArgType arg = _argTypes[name]!;

    assert(values.containsKey(name) || !arg.isRequired,
        'Story \'${_story.name}\' has no value provided for required arg \'$name\'');

    return values[name] ?? arg.defaultValue;
  }

  void updateStory(Story story) {
    _story = story;
    _argTypes = story.component.argTypes;
  }

  void update(String name, dynamic value) {
    _story.updateArg(name, value);
    isForced = false;
    notifyListeners();
    if (_appState != null) _updateRouteArgParams();
  }

  void reset() {
    _story.resetArgs();
    isForced = true;
    notifyListeners();
    if (_appState != null) _updateRouteArgParams();
  }

  void _updateRouteArgParams() {
    _appState!.argsUpdated();
  }

  @override
  void dispose() {
    _appState?.removeListener(_stateListener);
    super.dispose();
  }
}
