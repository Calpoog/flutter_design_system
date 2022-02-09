import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_design_system/src/controls/controls_panel.dart';
import 'package:flutter_design_system/src/docs/doc_canvas.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:flutter_design_system/src/ui/utils/section.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:provider/provider.dart';

class DocsPanel extends Panel {
  DocsPanel({Key? key}) : super(name: 'Docs', key: key);

  @override
  Widget build(BuildContext context) {
    final selectedStory = context.read<Story>();
    final component = selectedStory.component;
    final List<Story> stories = List.from(component.children as List<Story>);
    final primary = stories.removeAt(0);

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Center(
          child: KeyedSubtree(
            key: ValueKey(primary.component),
            child: SizedBox(
              width: min(constraints.maxWidth, 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H1(component.name),
                  ChangeNotifierProvider(
                    create: (context) => Arguments(primary),
                    child: Column(
                      children: [
                        DocCanvas(story: primary),
                        if (primary.component.argTypes.isNotEmpty)
                          Section(
                            child: ControlsPanel(),
                            margin: const EdgeInsets.only(bottom: 20.0),
                          ),
                      ],
                    ),
                  ),
                  if (component.markdown != null) MarkdownFile(file: component.markdown!),
                  if (component.markdownString != null) MarkdownString(string: component.markdownString!),
                  const SizedBox(height: 30),
                  if (stories.isNotEmpty) const H3('Stories', useRule: true),
                  for (final story in stories) ...[
                    H4(story.name, useRule: false),
                    ChangeNotifierProvider(
                      create: (context) => Arguments(story),
                      child: DocCanvas(story: story),
                    ),
                    if (story.markdown != null) MarkdownFile(file: story.markdown!),
                    if (story.markdownString != null) MarkdownString(string: story.markdownString!),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
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
    final appTheme = context.read<AppTheme>();
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyText1!.copyWith(fontFamily: 'NunitoSans', color: appTheme.body);
    final headingStyle = textStyle.copyWith(fontWeight: FontWeight.w900);
    const headingPadding = EdgeInsets.fromLTRB(0, 24, 0, 16);
    final _style = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      h1: headingStyle.copyWith(fontSize: 36),
      h1Padding: headingPadding,
      h2: headingStyle.copyWith(fontSize: 30),
      h2Padding: headingPadding,
      h3: headingStyle.copyWith(fontSize: 24),
      h3Padding: headingPadding,
      h4: headingStyle.copyWith(fontSize: 18),
      h4Padding: headingPadding,
      h5: headingStyle.copyWith(fontSize: 14),
      h5Padding: headingPadding,
      h6: headingStyle.copyWith(fontSize: 12),
      h6Padding: headingPadding,
      tableHead: textStyle.copyWith(fontWeight: FontWeight.w800),
      blockquote: headingStyle.copyWith(color: Colors.red),
      blockquotePadding: const EdgeInsets.only(left: 20.0),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 5.0, color: Colors.blueGrey.withOpacity(0.2)),
        ),
      ),
      p: textStyle,
      tableBody: textStyle,
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color.fromRGBO(229, 229, 229, 1)),
        ),
      ),
    );

    return MarkdownBody(
      data: string,
      styleSheet: _style,
      builders: {'code': CodeElementBuilder()},
    );
  }
}

class CodeBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(dynamic element, TextStyle? preferredStyle) {
    return CodeText(element.textContent);
  }
}

class BlockQuoteBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(dynamic element, TextStyle? preferredStyle) {
    return Container(
      child: AppText(element.textContent),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 5.0, color: Colors.black),
        ),
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    final text = element.textContent.trimRight();
    return SizedBox(
      width: element.textContent.contains('\n') ? double.infinity : null,
      child: HighlightView(
        text,
        language: language,
        theme: atomOneLightTheme,
        padding: const EdgeInsets.all(8),
        textStyle: const TextStyle(fontFamily: 'RobotoMono', fontSize: 12),
      ),
    );
  }
}
