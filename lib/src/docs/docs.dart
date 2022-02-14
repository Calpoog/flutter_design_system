import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/utils/text.dart';
import '../ui/utils/theme.dart';
import 'docs_panel.dart';
import '../models/documentable.dart';

class Docs extends StatelessWidget {
  const Docs(this.item, {Key? key}) : super(key: key);

  final Documentable item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (item.docWidget != null) item.docWidget!,
        if (item.markdownFile != null) MarkdownFile(file: item.markdownFile!),
        if (item.markdownString != null) MarkdownString(string: item.markdownString!),
      ],
    );
  }
}

class ReadingWidth extends StatelessWidget {
  const ReadingWidth({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SizedBox(
          width: min(800, constraints.maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class Paragraph extends StatelessWidget {
  const Paragraph({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: AppText(text),
    );
  }
}

abstract class Heading extends StatelessWidget {
  const Heading({Key? key, required this.text, required this.size, this.useRule = false}) : super(key: key);

  final String text;
  final double size;
  final bool useRule;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<AppTheme>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      margin: EdgeInsets.only(bottom: useRule ? 16 : 8),
      decoration: useRule ? BoxDecoration(border: Border(bottom: BorderSide(color: appTheme.border))) : null,
      child: AppText(
        text,
        size: size,
        weight: FontWeight.w900,
      ),
    );
  }
}

class H1 extends Heading {
  const H1(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 36,
          useRule: useRule,
        );
}

class H2 extends Heading {
  const H2(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 30,
          useRule: useRule,
        );
}

class H3 extends Heading {
  const H3(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 24,
          useRule: useRule,
        );
}

class H4 extends Heading {
  const H4(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 18,
          useRule: useRule,
        );
}

class H5 extends Heading {
  const H5(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 14,
          useRule: useRule,
        );
}

class H6 extends Heading {
  const H6(
    String text, {
    Key? key,
    bool useRule = false,
  }) : super(
          key: key,
          text: text,
          size: 12,
          useRule: useRule,
        );
}
