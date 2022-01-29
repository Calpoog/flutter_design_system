import 'package:flutter_storybook/models/arguments.dart';

class StoryPath {
  final String? path;
  final ArgValues? argValues;

  StoryPath({this.path, this.argValues});

  bool get isViewingStory => path == null;
}
