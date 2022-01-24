import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../component.dart';

class ComponentCanvas extends StatelessWidget {
  const ComponentCanvas(this.story, {Key? key}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final Arguments args = context.watch<ArgsNotifier>().args!;
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        child: Center(
          child: story.builder != null ? story.builder!(context, args) : story.component.builder!(context, args),
        ),
      ),
    );
  }
}
