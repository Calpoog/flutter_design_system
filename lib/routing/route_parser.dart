import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/routing/story_path.dart';

class StoryRouteInformationParser extends RouteInformationParser<StoryPath> {
  final Map<String, Story> stories;

  StoryRouteInformationParser(this.stories);

  @override
  Future<StoryPath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return StoryPath();
    }

    // Handle '/story/path'
    return StoryPath(path: uri.path, argValues: {});
  }

  @override
  RouteInformation restoreRouteInformation(StoryPath configuration) {
    return RouteInformation(location: configuration.path);
  }
}
