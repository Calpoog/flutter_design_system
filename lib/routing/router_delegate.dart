import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/routing/story_path.dart';
import 'package:flutter_storybook/storybook.dart';
import 'package:flutter_storybook/ui/component_view.dart';
import 'package:provider/provider.dart';

class StoryRouterDelegate extends RouterDelegate<StoryRouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StoryRouteState> {
  StoryRouterDelegate({required this.stories, GlobalKey<NavigatorState>? navigatorKey})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final Map<String, Story> stories;
  Story? story;

  setStory(Story story) {
    this.story = story;
    notifyListeners();
  }

  @override
  StoryRouteState? get currentConfiguration {
    return StoryRouteState(path: story?.path, argValues: story?.args);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey(story),
          child: MultiProvider(
            providers: [
              Provider(create: (context) => StoryRouter(this)),
              Provider.value(value: story),
            ],
            child: const StorybookHome(),
          ),
        ),
      ],
      onPopPage: (route, result) {
        return false;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(StoryRouteState configuration) {
    story = stories[configuration.path];
    return SynchronousFuture(null);
  }
}

class StoryRouter {
  final StoryRouterDelegate _delegate;

  StoryRouter(StoryRouterDelegate delegate) : _delegate = delegate;

  setStory(Story story) {
    _delegate.setStory(story);
  }
}
