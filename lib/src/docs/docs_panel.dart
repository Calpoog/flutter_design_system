import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:provider/provider.dart';

final _style = md.MarkdownStyleSheet(
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
);

class DocsPanel extends Panel {
  DocsPanel({Key? key}) : super(name: 'Docs', key: key);

  @override
  Widget build(BuildContext context) {
    final selectedStory = context.read<Story>();
    final component = selectedStory.component;
    final stories = component.children as List<Story>;

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: min(constraints.maxWidth, 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (component.markdown != null) MarkdownFile(file: component.markdown!),
                if (component.markdownString != null) MarkdownString(string: component.markdownString!),
                // "Primary"
                // TODO: Mini-panel and args/controls
                const AppText('Stories', size: 20),
                for (final story in stories) ...[
                  AppText(story.name, size: 16),
                  if (story.markdown != null) MarkdownFile(file: story.markdown!),
                  if (story.markdownString != null) MarkdownString(string: story.markdownString!),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MarkdownFile extends StatelessWidget {
  const MarkdownFile({
    Key? key,
    required this.file,
  }) : super(key: key);

  final String file;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString(file),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return MarkdownString(string: snapshot.data!);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MarkdownString extends StatelessWidget {
  const MarkdownString({
    Key? key,
    required this.string,
  }) : super(key: key);

  final String string;

  @override
  Widget build(BuildContext context) {
    return md.MarkdownBody(
      data: string,
      styleSheet: _style,
      builders: {'code': CodeBuilder()},
    );
  }
}

class CodeBuilder extends md.MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(dynamic element, TextStyle? preferredStyle) {
    return AppCode(element.textContent);
  }
}
