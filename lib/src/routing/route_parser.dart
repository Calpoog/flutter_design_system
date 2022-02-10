import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_design_system/src/routing/story_route_state.dart';

class StoryRouteInformationParser extends RouteInformationParser<StoryRouteState> {
  // Url to navigation state
  @override
  Future<StoryRouteState> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '');

    var parts = uri.path.split('/');
    bool isViewingDocs = false;
    String? path;
    if (parts.length > 2) {
      isViewingDocs = parts[1] == 'Docs';
      path = '/' + parts.sublist(2).join('/');
    }
    final args = _parseQuerySubParams(uri.queryParameters['args']);
    final globals = _parseQuerySubParams(uri.queryParameters['globals']);

    return SynchronousFuture(
      StoryRouteState(
        path: path,
        argValues: args,
        globals: globals,
        isViewingDocs: isViewingDocs,
      ),
    );
  }

  // Navigation state to url
  @override
  RouteInformation restoreRouteInformation(StoryRouteState configuration) {
    return configToRouteInfo(configuration);
  }
}

RouteInformation configToRouteInfo(StoryRouteState configuration) {
  final args = _buildQuerySubParams('args', configuration.argValues);
  final globals = _buildQuerySubParams('globals', configuration.globals);
  String params = [
    if (args != null) args,
    if (globals != null) globals,
  ].join('&');

  if (params.isNotEmpty) params = '?' + params;

  return RouteInformation(
      location: configuration.path == null
          ? ''
          : '${configuration.isViewingDocs ? '/Docs' : '/Story'}${configuration.path}$params');
}

String? _buildQuerySubParams(String name, Map<String, String>? values) {
  String? param;
  if (values != null) {
    final List<String> pairs = [];
    for (final pair in values.entries) {
      pairs.add('${pair.key}:${Uri.encodeComponent(pair.value.toString())}');
    }
    if (pairs.isNotEmpty) {
      param = '$name=${pairs.join(';')}';
    }
  }
  return param;
}

Map<String, String> _parseQuerySubParams(String? params) {
  final Map<String, String> map = {};
  if (params != null) {
    final pairs = params.split(';');
    for (final pair in pairs) {
      final tuple = pair.split(':');
      if (tuple.length == 2) {
        map[tuple[0]] = Uri.decodeComponent(tuple[1]);
      }
    }
  }
  return map;
}
