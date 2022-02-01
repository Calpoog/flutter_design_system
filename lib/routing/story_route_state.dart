class StoryRouteState {
  late final String? path;
  late final Map<String, String>? argValues;
  final Map<String, String> globals;

  StoryRouteState({this.path, this.argValues, required this.globals});
}
