import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/routing/story_path.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/component_view.dart';
import 'package:provider/provider.dart';

class StoryRouterDelegate extends RouterDelegate<StoryRouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StoryRouteState> {
  StoryRouterDelegate({required this.stories, GlobalKey<NavigatorState>? navigatorKey, required this.state})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    state.addListener(_stateListener);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState state;
  final Map<String, Story> stories;

  _stateListener() {
    notifyListeners();
  }

  @override
  void dispose() {
    state.removeListener(_stateListener);
    super.dispose();
  }

  @override
  StoryRouteState? get currentConfiguration {
    return StoryRouteState(path: state.story?.path, argValues: state.story?.args);
  }

  // @override
  // Future<bool> popRoute() {
  //   return SynchronousFuture(false);
  // }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (state.story == null) const MaterialPage(child: SizedBox()),
        if (state.story != null)
          MaterialPage(
            name: state.story!.name,
            key: ValueKey(state.story),
            child: MultiProvider(
              providers: [
                Provider.value(value: state.story),
              ],
              child: const ComponentView(),
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
    final story = stories[configuration.path];
    state.setStory(story);
    return SynchronousFuture(null);
  }
}

class AppState extends ChangeNotifier {
  Story? story;
  Arguments? args;

  setStory(Story? story) {
    this.story = story;
    setArguments(story != null ? Arguments(story) : null);
  }

  setArguments(Arguments? args) {
    this.args?.removeListener(_argumentListener);
    args?.addListener(_argumentListener);
    this.args = args;
    notifyListeners();
  }

  _argumentListener() {
    notifyListeners();
  }

  @override
  void dispose() {
    args?.removeListener(_argumentListener);
    super.dispose();
  }
}
