import 'package:flutter/material.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/ui/component_view.dart';
import 'package:provider/provider.dart';

Route<dynamic>? generateRoute(
  BuildContext context,
  Map<String, Story> stories,
  RouteSettings settings,
) {
  final uri = Uri.parse(settings.name ?? '/');
  final story = stories[uri.path];
  debugPrint(uri.toString());
  if (story != null) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => Provider.value(
        value: story,
        child: const ComponentView(),
      ),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
  debugPrint(uri.queryParameters.toString());
  return MaterialPageRoute(builder: (_) => const SizedBox());
}
