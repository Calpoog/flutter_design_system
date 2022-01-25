import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:provider/provider.dart';

final _style = MarkdownStyleSheet(
  h1: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
  h2: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
  h3: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
  h4: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
  h5: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
  h6: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
  horizontalRuleDecoration: const BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 1, color: Color.fromRGBO(229, 229, 229, 1)),
    ),
  ),
  blockSpacing: 20,
);

class Docs extends StatelessWidget {
  const Docs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Story story = context.read<StoryNotifier>().story!;
    return FutureBuilder(
      future: rootBundle.loadString('test.md'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Markdown(
            data: snapshot.data!,
            styleSheet: _style,
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
