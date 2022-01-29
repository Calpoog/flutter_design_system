// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_storybook/models/story.dart';
// import 'package:flutter_storybook/routing/story_path.dart';
// import 'package:flutter_storybook/storybook.dart';

// class StoryRouterDelegate extends RouterDelegate<StoryPath>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<StoryPath> {
//   StoryRouterDelegate(this.stories) : navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   final GlobalKey<NavigatorState> navigatorKey;

//   final Map<String, Story> stories;
//   Story? story;

//   @override
//   StoryPath? get currentConfiguration {
//     return StoryPath(path: story?.path, argValues: story?.args);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: navigatorKey,
//       pages: const [MaterialPage(child: StorybookHome())],
//       onPopPage: (route, result) {
//         if (!route.didPop(result)) {
//           return false;
//         }

//         // Update the list of pages by setting _selectedBook to null
//         story = null;
//         notifyListeners();

//         return true;
//       },
//     );
//   }

//   @override
//   Future<void> setNewRoutePath(StoryPath configuration) async {
//     story = stories[configuration.path];
//     // TODO put new args into the story
//   }
// }
