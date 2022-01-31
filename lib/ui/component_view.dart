import 'package:flutter/material.dart';
import 'package:flutter_storybook/routing/router_delegate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_storybook/ui/panels/canvas/background_popup.dart';
import 'package:flutter_storybook/ui/panels/canvas/viewport_popup.dart';
import 'package:flutter_storybook/models/story.dart';
import 'package:flutter_storybook/models/arguments.dart';
import 'package:flutter_storybook/ui/panels/canvas/canvas_panel.dart';
import 'package:flutter_storybook/ui/panels/panel.dart';
import 'package:flutter_storybook/ui/panels/docs_panel.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Story story = context.read<Story>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Arguments(story, context.read<AppState>())),
      ],
      child: PanelGroup(panels: [
        CanvasPanel(),
        DocsPanel(),
      ]),
    );
  }
}
