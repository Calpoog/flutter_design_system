import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/docs/docs_panel.dart';
import 'package:flutter_design_system/src/models/documentable.dart';

class DocsWidget extends StatelessWidget {
  const DocsWidget(this.item, {Key? key}) : super(key: key);

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
