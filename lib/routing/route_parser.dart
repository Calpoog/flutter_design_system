import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/routing/story_path.dart';

class StoryRouteInformationParser extends RouteInformationParser<StoryRouteState> {
  // Url to navigation state
  @override
  Future<StoryRouteState> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');

    final Map<String, String> args = {};
    final argsStr = uri.queryParameters['args'];

    if (argsStr != null) {
      final pairs = argsStr.split(';');
      for (final pair in pairs) {
        final arg = pair.split(':');
        if (arg.length == 2) {
          args[arg[0]] = args[1]!;
        }
      }
    }

    return StoryRouteState(path: uri.path, argValues: args);
  }

  // Navigation state to url
  @override
  RouteInformation restoreRouteInformation(StoryRouteState configuration) {
    String argStr = '';
    if (configuration.argValues != null) {
      final List<String> args = [];
      for (final arg in configuration.argValues!.entries) {
        args.add('${arg.key}:${Uri.encodeComponent(arg.value.toString())}');
      }
      argStr = 'args=${args.join(';')}';
    }
    return RouteInformation(location: configuration.path == null ? '' : '${configuration.path}?$argStr');
  }
}
