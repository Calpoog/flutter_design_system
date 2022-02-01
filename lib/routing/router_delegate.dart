import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/globals.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/routing/story_route_state.dart';
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
    return StoryRouteState(
      path: state.story?.path,
      argValues: state.story?.serializeArgs(),
      globals: state.globals.serialize(),
    );
  }

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
                ChangeNotifierProvider.value(value: state.args),
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
    if (story != null) {
      state.globals.restore(configuration.globals);
      state.restoreStory(story, configuration.argValues ?? {});
    } else {
      state.args = null;
    }
    return SynchronousFuture(null);
  }
}

class AppState extends ChangeNotifier {
  Story? story;
  Arguments? args;
  final globals = Globals();

  AppState() {
    globals.addListener(_listener);
  }

  // Restores a story from url, driven by browser/user URL updates, not UI
  restoreStory(Story story, Map<String, String> queryArgs) {
    final isStoryChange = this.story == story;
    this.story = story;
    story.restoreArgs(queryArgs);
    // Only make args notify its listeners if the story is the same, otherwise
    // It notifies before the router rebuilds the right side and the current
    // Story will rerender with wrong args.
    _updateArgs(isStoryChange);
    notifyListeners();
  }

  // Called by the explorer to change stories
  setStory(Story story) {
    this.story = story;
    _updateArgs();
    notifyListeners();
  }

  // Updates/listens to the current Arguments object for the selected story
  _updateArgs([bool notify = false]) {
    if (args == null) {
      args = Arguments(story!);
      args!.addListener(_listener);
    } else {
      args!.updateStory(story!);
    }
    args!.isForced = true;

    if (notify) {
      args!.notifyListeners();
    }
  }

  _listener() {
    notifyListeners();
  }

  @override
  void dispose() {
    args?.removeListener(_listener);
    globals.removeListener(_listener);
    super.dispose();
  }
}
