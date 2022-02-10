import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_design_system/src/controls/controls_panel.dart';
import 'package:flutter_design_system/src/docs/doc_canvas.dart';
import 'package:flutter_design_system/src/docs/docs.dart';
import 'package:flutter_design_system/src/docs/docs_panel.dart';
import 'package:flutter_design_system/src/models/story.dart';
import 'package:flutter_design_system/src/models/arguments.dart';
import 'package:flutter_design_system/src/ui/utils/section.dart';
import 'package:flutter_design_system/src/ui/utils/text.dart';
import 'package:provider/provider.dart';

class DocsPage extends StatelessWidget {
  const DocsPage({
    Key? key,
    required this.story,
  }) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final component = story.component;
    final List<Story> stories = List.from(component.children as List<Story>);
    final primary = stories.removeAt(0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
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
                  DocsWidget(component),
                  const SizedBox(height: 30),
                  if (stories.isNotEmpty) const H3('Stories', useRule: true),
                  for (final story in stories) ...[
                    H4(story.name, useRule: false),
                    ChangeNotifierProvider(
                      create: (context) => Arguments(story),
                      child: DocCanvas(story: story),
                    ),
                    DocsWidget(story),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
