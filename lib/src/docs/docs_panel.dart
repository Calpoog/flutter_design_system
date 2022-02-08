import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_design_system/src/docs/doc_canvas.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/ui/utils/theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:flutter_design_system/src/ui/panels/panel.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:provider/provider.dart';

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (component.markdown != null) MarkdownFile(file: component.markdown!),
                if (component.markdownString != null) MarkdownString(string: component.markdownString!),
                // "Primary"
                // TODO: Mini-panel and args/controls
                const AppText('Stories', size: 20),
                for (final story in stories) ...[
                  AppText(story.name, size: 16),
                  DocCanvas(story: story),
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
    final appTheme = context.read<AppTheme>();
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyText1!.copyWith(fontFamily: 'NunitoSans', color: appTheme.body);
    final headingStyle = textStyle.copyWith(fontWeight: FontWeight.w900);
    final _style = md.MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      h1: headingStyle.copyWith(fontSize: 36),
      h2: headingStyle.copyWith(fontSize: 30),
      h3: headingStyle.copyWith(fontSize: 24),
      h4: headingStyle.copyWith(fontSize: 18),
      h5: headingStyle.copyWith(fontSize: 14),
      h6: headingStyle.copyWith(fontSize: 12),
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

class BlockQuoteBuilder extends md.MarkdownElementBuilder {
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
