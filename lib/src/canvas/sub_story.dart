import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/arguments.dart';
import '../models/globals.dart';
import '../models/story.dart';
import '../consumer.dart' as consumer;

class SubStory extends StatelessWidget {
  const SubStory({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final args = consumer.Arguments(context.watch<Arguments>());
    final globals = consumer.Globals(context.read<Globals>());

    return story.builder != null
        ? story.builder!(context, args, globals)
        : story.component.builder!(context, args, globals);
  }
}
