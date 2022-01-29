import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;
import 'package:flutter_storybook/ui/panels/panel.dart';
import 'package:flutter_storybook/ui/utils/text.dart';

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
    return FutureBuilder(
      future: rootBundle.loadString('test.md'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (_, constraints) => SingleChildScrollView(
              primary: false,
              child: Center(
                child: SizedBox(
                  width: min(constraints.maxWidth, 800),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: md.MarkdownBody(
                      data: snapshot.data!,
                      styleSheet: _style,
                      builders: {'code': CodeBuilder()},
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CodeBuilder extends md.MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(dynamic element, TextStyle? preferredStyle) {
    return AppCode(element.textContent);
  }
}
