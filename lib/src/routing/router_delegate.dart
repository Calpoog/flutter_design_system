import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_design_system/src/models/documentaton.dart';
import 'package:flutter_design_system/src/models/globals.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/routing/route_parser.dart';
import 'package:flutter_design_system/src/routing/story_route_state.dart';
import 'package:flutter_design_system/src/models/arguments.dart';

class StoryRouterDelegate extends RouterDelegate<StoryRouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StoryRouteState> {
  StoryRouterDelegate({required this.stories, required this.state}) {
    state.addListener(_stateListener);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    return state.toRouteConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: const [MaterialPage(child: SizedBox())],
      onPopPage: (route, result) {
        return false;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(StoryRouteState configuration) {
    final story = stories[configuration.path];
    if (story != null) {
      state.isViewingDocs = configuration.isViewingDocs;
      state.globals.restore(configuration.globals);
      state.restoreStory(story, configuration.argValues ?? {});
    }
    return SynchronousFuture(null);
  }
}

// class CustomPlatformRouteInformationProvider extends PlatformRouteInformationProvider {
//   CustomPlatformRouteInformationProvider({required RouteInformation initialRouteInformation,}) : super(initialRouteInformation: initialRouteInformation);

//   @override
//   void routerReportsNewRouteInformation(RouteInformation routeInformation, {required RouteInformationReportingType type}) {
//     final bool replace =
//       type == RouteInformationReportingType.neglect ||
//       (type == RouteInformationReportingType.none &&
//        _valueInEngine.location == routeInformation.location);
//     SystemNavigator.selectMultiEntryHistory();
//     SystemNavigator.routeInformationUpdated(
//       location: routeInformation.location!,
//       state: routeInformation.state,
//       replace: replace,
//     );
//     _value = routeInformation;
//     _valueInEngine = routeInformation;
//   }
// }

class AppState extends ChangeNotifier {
  Story? story;
  bool isArgsUpdating = false;
  bool isRestoring = false;
  bool isViewingDocs = false;
  final globals = Globals();

  AppState() {
    globals.addListener(_listener);
  }

  view(isDocs) {
    isViewingDocs = isDocs;
    notifyListeners();
  }

  // Restores a story from url, driven by browser/user URL updates, not UI
  restoreStory(Story story, Map<String, String> queryArgs) {
    isRestoring = true;
    this.story = story;
    if (story is! Documentation) story.restoreArgs(queryArgs);
    notifyListeners();
    isRestoring = false;
  }

  // Called by the explorer to change stories
  setStory(Story story) {
    if (story is Documentation) isViewingDocs = true;
    this.story = story;
    notifyListeners();
  }

  // Arguments that are attached to app state/url can tell state to update
  argsUpdated() {
    // Explicitly replace history because router is inaccessible to use router.neglect()
    SystemNavigator.routeInformationUpdated(
      location: configToRouteInfo(toRouteConfig()).location ?? '',
      replace: true,
    );
  }

  _listener() {
    notifyListeners();
  }

  toRouteConfig() {
    return StoryRouteState(
      path: story?.path,
      argValues: isViewingDocs || story is Documentation ? {} : story?.serializeArgs(),
      globals: globals.all(),
      isViewingDocs: isViewingDocs,
    );
  }

  @override
  void dispose() {
    globals.removeListener(_listener);
    super.dispose();
  }
}
