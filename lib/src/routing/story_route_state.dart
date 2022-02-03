class StoryRouteState {
  late final String? path;
  late final Map<String, String>? argValues;
  final Map<String, String> globals;
  final bool isViewingDocs;

  StoryRouteState({
    this.path,
    this.argValues,
    required this.globals,
    required this.isViewingDocs,
  });
}
